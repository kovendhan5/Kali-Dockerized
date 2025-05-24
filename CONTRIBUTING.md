# Contributing to Kali Dockerized

Thank you for your interest in contributing to this project! 🎉

## 🚀 Quick Start

1. **Fork** the repository
2. **Clone** your fork locally
3. **Create** a new branch for your feature
4. **Make** your changes
5. **Test** your changes
6. **Submit** a pull request

## 📋 Types of Contributions

We welcome contributions in several areas:

### 🐛 Bug Reports
- Use the issue tracker to report bugs
- Include reproduction steps
- Specify which image variant you're using

### ✨ Feature Requests
- Suggest new image variants
- Propose script improvements
- Request documentation enhancements

### 📝 Documentation
- Improve existing documentation
- Add missing information
- Fix typos and formatting

### 🔧 Code Contributions
- New Dockerfile optimizations
- Script improvements
- Build automation enhancements

## 🏗️ Development Guidelines

### Dockerfile Changes
- Test all variants before submitting
- Ensure images build successfully
- Document size impact
- Follow existing optimization patterns

### Script Changes
- Test on Windows and Linux (where applicable)
- Maintain backward compatibility
- Add appropriate error handling
- Update documentation

### Documentation Updates
- Keep README.md updated
- Update relevant docs/ files
- Maintain consistent formatting

## 🧪 Testing

Before submitting changes:

1. **Build test**: Ensure Dockerfiles build successfully
2. **Size test**: Check image sizes with `scripts/utils/check-image-sizes.bat`
3. **Function test**: Verify containers start and function properly
4. **Script test**: Test any modified scripts

## 📁 Repository Structure

Please maintain the organized structure:
- **Dockerfiles** → `dockerfiles/`
- **Build scripts** → `scripts/build/`
- **Push scripts** → `scripts/push/`
- **Run scripts** → `scripts/run/`
- **Utilities** → `scripts/utils/`
- **Documentation** → `docs/`

## 💬 Getting Help

- Check existing [issues](https://github.com/kovendhan5/kali-dockerized/issues)
- Review the [documentation](docs/)
- Ask questions in issue discussions

## 📄 License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for helping make this project better! 🙏
