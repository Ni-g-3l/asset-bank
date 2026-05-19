# Asset Bank

## Overview

This open-source repository contains a curated collection of **binary data files** used to test, validate, and benchmark **3D software, tools, and pipelines**.

The assets are provided strictly for **technical and functional testing** purposes, such as:

* File format compatibility
* Import/export validation
* Rendering and cache evaluation
* Pipeline robustness and regression testing

The repository includes, but is not limited to:

* Image formats: `.png`, `.exr`, `.png`, `.jpg`
* Geometry and cache formats: `.abc`, `.obj`, `.fbx`
* Textures, reference data, and miscellaneous binary assets
* Scripts used to create new assets

---

## Repository Structure

Assets are typically organized by category or file format:

```
/geo
  ├─ baked/
/img
  ├─ vectors/
  ├─ sequences/
  ├─ animated/
/music
/vids
```

This structure may evolve over time as new test assets are added.

---

## Scripts

Utility scripts for generating test assets are located in `/scripts`.

### `palette.v`

Generates a palette preview PNG image from hex color codes.

**Usage:**
```
v run scripts/palette.v <output.png> <color1> [color2 ...]
```

**Example:**
```
v run scripts/palette.v p.png #FF9300 #00FF00 #0000FF
```

This creates a horizontal swatch image (240px per color, 320px tall) with HEX labels beneath each block. Requires no external dependencies — uses V's built-in `stbi` module for PNG output.

---

## Intended Use

✅ **Permitted Uses**

* Open-source software development
* Automated testing and CI pipelines
* Education and research
* Debugging, profiling, and validation

❌ **Not Intended**

* Production or commercial content creation
* Redistribution without respecting original licenses
* Use as final artistic or creative assets

---

## Assets Licensing

All licensing information for assets in this repository is centralized in the **`LICENSES.md`** file.

### How Licensing Is Organized

* **`LICENSE`**
  Applies to the repository documentation, metadata, and source files only.

* **`LICENSES.md`**
  Contains the license details for **all binary assets** stored in this repository, including:

  * Asset names and paths
  * SPDX license identifiers
  * Attribution requirements (if any)
  * Source or origin information

Each asset or asset group is listed explicitly in `LICENSES.md`.

---

### Important Notes

* Assets **may use different licenses**
* Always check `LICENSES.md` **before using, redistributing, or modifying any asset**
* If an asset is not listed in `LICENSES.md`, its license should be considered **undefined**

---

### Missing or Unclear License Information

If you find:

* An asset missing from `LICENSES.md`
* An unclear or incorrect license entry

Please report it immediately:

* 🐙 **GitHub Issues:** Open an issue labeled `license` or `license-question`

Do **not** use the asset until licensing has been clarified.

---

## Contributions

Contributions are welcome and encouraged.

By contributing, you agree that:

* You have the right to submit the asset
* Each contributed asset includes **clear licensing information**
* SPDX identifiers are provided where possible

Pull requests without proper licensing information may be rejected.

---

## Disclaimer

All assets are provided **“as is”**, without warranty of any kind.
The maintainers are not responsible for misuse or misinterpretation of licensing terms.

Always verify licenses before using any asset.
