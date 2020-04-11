#!/bin/env zsh
git clone https://github.com/apple/sourcekit-lsp.git
cd sourcekit-lsp/Editors/vscode/
npm run createDevPackage
code --install-extension out/sourcekit-lsp-vscode-dev.vsix