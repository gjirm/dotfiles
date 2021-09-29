# Install cmd installer Scoop (https://scoop.sh/) includin my apps

Write-Host "--> Installing scoop..." -ForegroundColor Green
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
# or shorter
# iwr -useb get.scoop.sh | iex

Write-Host "--> Adding scoop extras bucket..." -ForegroundColor Green
scoop bucket add extras

Write-Host "--> Installing apps..." -ForegroundColor Green

# https://smallstep.com/cli/
scoop bucket add smallstep https://github.com/smallstep/scoop-bucket.git
scoop install smallstep/step

# https://github.com/FiloSottile/age
scoop install age

# https://github.com/junegunn/fzf
scoop install fzf

# https://github.com/sharkdp/fd
scoop install fd

# https://github.com/minio/mc
scoop install minio-client

# https://github.com/zyedidia/micro
scoop install micro

# https://github.com/jedisct1/minisign
scoop install minisign

# https://github.com/gopasspw/gopass
scoop install gopass

# https://obsidian.md/
scoop install obsidian

# https://github.com/OpenVPN/easy-rsa
#scoop install easyrsa

# https://github.com/gokcehan/lf
scoop install lf

# https://github.com/hashicorp/terraform
scoop install terraform

# https://github.com/hashicorp/vagrant
#scoop install vagrant

# https://eternallybored.org/misc/wget/
#scoop install wget

# https://github.com/facebook/zstd
#scoop install zstd

# https://github.com/goreleaser/goreleaser/
scoop bucket add goreleaser https://github.com/goreleaser/scoop-bucket.git
scoop install goreleaser

# https://github.com/taskctl/taskctl
# scoop bucket add taskctl https://github.com/taskctl/scoop-taskctl.git
# scoop install taskctl

# https://key.pub
scoop bucket add keys.pub https://github.com/keys-pub/scoop-bucket
scoop install libfido2
scoop install keys

Write-Host "--> Done <--" -ForegroundColor Green