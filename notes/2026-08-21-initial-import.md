# Initial Tabor import notes

The A1222 kernel archive in `~/Downloads` is mislabeled as `.tar.gz`; `file`
identifies it as a GNU/POSIX tar archive and `gzip -t` correctly rejects it.

The useful source-facing payload is:

```text
linux-image-5.4-rc3-X1000_X5000_A1222/
  A1222_and_QEMU_e500v2/src/
    tabor_5.4-1.patch
    tabor3.dts
    tabor-5.4-rc3.config
```

The vendor patch touches:

```text
arch/powerpc/platforms/85xx/Kconfig
arch/powerpc/platforms/85xx/Makefile
arch/powerpc/platforms/85xx/tabor.c
sound/soc/fsl/fsl_ssi.c
sound/soc/fsl/Kconfig
sound/soc/fsl/Makefile
sound/soc/fsl/tabor.c
```

The DTS identifies:

```text
model = "varisys,TABOR";
compatible = "varisys,TABOR";
```

The config includes the expected PowerPC/e500/SPE shape:

```text
CONFIG_PPC=y
CONFIG_BOOKE=y
CONFIG_SPE=y
CONFIG_SMP=y
CONFIG_MATH_EMULATION=y
CONFIG_MODULES=y
CONFIG_DEVTMPFS=y
CONFIG_BLK_DEV_INITRD=y
```

