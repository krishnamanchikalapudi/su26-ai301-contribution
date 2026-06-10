# Contribution [#1]: CI support for Slang testing

**Contribution Number:** 1  
**Student:** [Your Name]  
**Issue:** [AcademySoftwareFoundation/MaterialX #2668](https://github.com/AcademySoftwareFoundation/MaterialX/issues/2668)  
**Status:** Phase I — In Progress

---

## Why I Chose This Issue

This issue sits at the intersection of shader language tooling and continuous integration infrastructure — two areas I find deeply interesting. MaterialX is a widely adopted standard in the VFX and film industry, and ensuring its Slang backend is reliably tested on CI is critical for long-term quality. The issue is labeled **"help wanted"** by the maintainers, signaling it is genuinely open for community contribution.

I also see this as a great opportunity to learn how large open-source projects structure their CI workflows (GitHub Actions, image comparison testing, compiler-based validation), and to contribute something practically useful rather than cosmetic.

---

## Understanding the Issue

### Problem Description

MaterialX recently gained a Slang shader generator (with Slang support exposed in both Python and JavaScript), but there is **no CI coverage** for validating Slang-generated shaders. Developers can run Slang tests locally, but CI pipelines lack the image comparison infrastructure needed to automatically verify correctness across commits.

### Expected Behavior

Slang shader generation should be validated in CI automatically on every pull request and merge, similar to how GLSL and MSL shader compilation is currently tested. The workflow should:
1. Download a prebuilt release of Slang (the `slangc` compiler) from GitHub.
2. Run `generateShader.py` with `slangc` as the validation command.
3. Report any compilation or comparison failures as CI failures.

### Current Behavior

- CI has no Slang-specific test step.
- Developers must run Slang validation tests manually on their local machines.
- There is no image comparison infrastructure on CI for Slang output.

### Affected Components

- **CI workflow files** (GitHub Actions `.yml` files in `.github/workflows/`)
- **`generateShader.py`** — the Python script used for shader generation and validation, which already accepts a compiler command as an argument
- **MaterialX Slang generator** (`source/MaterialXGenShader` / Slang backend) — already exposed in Python and JavaScript as of [this commit](https://github.com/AcademySoftwareFoundation/MaterialX/commit/ef1d56c9470e42f6abcc338875bd083e6d687ff0)

### Additional Context from Issue Discussion

- Maintainer `jstone-lucasfilm` confirmed the scope: CI support specifically for *Slang* testing.
- Contributor `kwokcb` suggested downloading a Slang GitHub release and passing `slangc` as the validation command to `generateShader.py`, following the same pattern used for GLSL and MSL.
- `kwokcb` also noted that Slang releases do **not** include RHI, which actually simplifies CI setup (no need to build RHI from source).
- A related issue in the Slang repo — [shader-slang/slang#8995](https://github.com/shader-slang/slang/issues/8995) ("Create CI test coverage for MaterialX repo") — has already been **completed**, indicating upstream coordination is in place.
