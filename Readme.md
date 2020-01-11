# ECE 342

### 为了防止让这门作业变成一个人的作业，我决定认真写下这个Readme

## Target
小目标：两个人稳过A

## Enviroment
1. 编译： Quartus Prime Lite Edition 18.1 (windows)
   - Device: 5CSEMA5F31C6 （应该用不到）
   - Programmer:
       1. Hardware Setup 确认连接上了板子
       2. Auto Detect 选择 5CSEMA5
       3. Add File
       4. Start
2. VCS: Git (暂时先用自己服务器了)
   - `git clone ece@yucanwu.com:git/ece342.git`
3. 写码：Visual Studio Code
   - 在目录下有这么个文件 [VSCode_plugins.txt](./VSCode_plugins.txt) 里面放了一些我觉得比较有用的VSCode插件，可以按名字在侧边栏搜索，或者点链接也可以 （实在懒 我帮你装）
   - 这个文件是markdown格式，打开VSCode点击右上角有一个 "Open Preview" 的小按钮 （一个小窗户带一个放大镜的图标）可以更舒服的看这个文件
   - 注：安装了Comment Anchors之后可以点开左侧一个 锚 的图标按钮
     - 在Workspace anchors里面
       - 所有REVIEW是我修改的地方（sv文件），可以点击直接跳转
       - TODO是教授写的，需要我们修改的地方
     - 点开文件后 在File Anchors里面
       - 所有NOTE是我后加的备注
4. 一点小建议
   - 在Git terminal里面运行这行 <br>
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
   - 以后只要运行 git lg 能看到更好看的版本更新记录

   - VS Code 打开PDF这个功能不太好用，所以最好还是直接用别的软件打开

## Directories
- See file [dir.md](dir.txt)

“未完 - 待续”