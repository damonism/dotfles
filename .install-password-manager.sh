#/bin/sh
# See https://www.chezmoi.io/user-guide/advanced/install-your-password-manager-on-init/
# exit immediately if password-manager-binary is already in $PATH
type bw >/dev/null 2>&1 && exit

case "$(uname -s)" in
Darwin)
    # commands to install password-manager-binary on Darwin
    curl -L -o /tmp/bitwarden-cli.zip 'https://vault.bitwarden.com/download/?app=cli&platform=macos'
    unzip -j /tmp/bitwarden-cli.zip -d /usr/local/bin/
    ;;
Linux)
    # commands to install password-manager-binary on Linux
    wget -O /tmp/bitwarden-cli.zip 'https://vault.bitwarden.com/download/?app=cli&platform=linux'
    unzip -j /tmp/bitwarden-cli.zip -d /usr/local/bin/
    ;;
*)
    echo "unsupported OS"
    exit 1
    ;;
esac
