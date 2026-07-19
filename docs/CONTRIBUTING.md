# CONTRIBUTING.md - Supri POS Contribution Guidelines

## 1. Development Workflow
1. **Fork the Repository:** Create a personal fork of the codebase.
2. **Create Feature Branch:** Branch out from `main` using standard naming formats:
   * `feat/feature-name`
   * `fix/bug-fix-name`
   * `docs/documentation-name`
3. **Write Clean Code:** Follow the directives defined in [CODING_STANDARDS.md](file:///home/lele/zProject/projects/main_projects/supri/docs/CODING_STANDARDS.md).
4. **Write Tests:** Add unit/widget tests to cover the new functionality. Verify they all pass before submitting:
   ```bash
   flutter test
   ```
5. **Submit PR:** Open a Pull Request targeting the `main` branch. Provide a detailed description of your changes.

## 2. Commit Message Guidelines
Use Conventional Commits standard:
* `feat: add printer setup page`
* `fix: correct drawer cash out calculation`
* `docs: update API endpoints spec`
