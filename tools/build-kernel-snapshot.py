#!/usr/bin/env python3
"""Consume a pinned canonical export using dpkg-source and ordinary Kbuild."""
import argparse, hashlib, json, pathlib, shutil, subprocess
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--source-cache',type=pathlib.Path,required=True)
p.add_argument('--work',type=pathlib.Path,required=True)
p.add_argument('--snapshot',type=pathlib.Path,default=pathlib.Path(__file__).resolve().parents[1]/'snapshots/polaris-be-20261107')
p.add_argument('--cross-compile',default='powerpc-linux-gnu-')
p.add_argument('--jobs',type=int,default=4)
p.add_argument('--prepare-only',action='store_true')
a=p.parse_args()
if a.jobs < 1: p.error('jobs must be positive')
a.snapshot=a.snapshot.resolve(); a.source_cache=a.source_cache.resolve(); a.work=a.work.resolve()
m=json.loads((a.snapshot/'manifest.json').read_text())
def sha(f):
 with f.open('rb') as h: return hashlib.file_digest(h,'sha256').hexdigest()
def verify(f,expected):
 if sha(f)!=expected: raise SystemExit('SHA256 mismatch: '+str(f))
def run(*cmd): subprocess.run(list(map(str,cmd)),check=True)
for name,meta in m['source_files'].items(): verify(a.source_cache/name,meta['sha256'])
for patch in m['patches']: verify(a.snapshot/'patches'/patch['file'],patch['sha256'])
verify(a.snapshot/'kernel.config',m['config_sha256'])
a.work.mkdir(parents=True,exist_ok=False)
src=a.work/'source'; out=a.work/'output'; out.mkdir()
dsc=next(name for name in m['source_files'] if name.endswith('.dsc'))
# Exact hashes above authenticate inputs; no online key lookup or source refresh.
run('dpkg-source','--no-check','-x',a.source_cache/dsc,src)
for patch in m['patches']:
 f=a.snapshot/'patches'/patch['file']
 run('git','-C',src,'apply','--check',f)
 run('git','-C',src,'apply',f)
shutil.copyfile(a.snapshot/'kernel.config',out/'.config')
make=['make','-C',src,'O='+str(out),'ARCH=powerpc','CROSS_COMPILE='+a.cross_compile]
run(*make,'olddefconfig')
verify(out/'.config',m['config_sha256'])
if not a.prepare_only: run(*make,'-j'+str(a.jobs),'vmlinux','modules','dtbs')
receipt={'canonical_commit':m['canonical_commit'],'config_sha256':sha(out/'.config'),'status':'prepared' if a.prepare_only else 'compiled','hardware_acceptance':False,'gcc':subprocess.check_output([a.cross_compile+'gcc','-dumpfullversion'],text=True).strip()}
(a.work/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps(receipt))
