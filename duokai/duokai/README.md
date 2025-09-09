# Chrome 多开快捷方式生成器

一个简单的 Windows 批处理脚本，用于批量生成多个独立的 Google Chrome 快捷方式。每个快捷方式使用不同的用户数据目录和基础浏览器指纹参数（语言、窗口大小、User-Agent），实现多账号登录、环境隔离或基础防关联用途。



## 🚀 功能特点

- ✅ 自动生成多个 Chrome 快捷方式（数量可自定义）
- ✅ 每个实例使用独立用户数据目录，支持多账号同时登录
- ✅ 基础指纹变化：
  - 语言（`--lang`）
  - 窗口大小（`--window-size`）
  - User-Agent（`--user-agent`）
- ✅ 自动创建所需文件夹
- ✅ 支持一键运行，无需安装额外软件

## 📦 使用条件

本脚本仅适用于 **Windows 系统**，请确保满足以下条件：

| 条件 | 说明 |
|------|------|
| **操作系统** | Windows 7 / 8 / 10 / 11 或 Windows Server |
| **Chrome 浏览器** | 已安装 Google Chrome（默认路径：`C:\Program Files\Google\Chrome\Application\chrome.exe`） |
| **磁盘权限** | 脚本中指定的路径需有读写权限（如 `G:\google\...`） |
| **VBScript 支持** | 系统需支持 `.vbs` 脚本调用（默认开启） |
| **杀毒软件** | 部分安全软件可能拦截 `.bat` 或 `.vbs` 脚本，请临时关闭或添加白名单 |

> ⚠️ 不支持 macOS、Linux 或 ARM 设备（如 Surface Pro X）

## ⚙️ 参数设置说明

你可以在脚本开头修改以下关键参数，按需定制行为：

### 1. 数据存储路径.默认创建以下路径。
```bat
set "UserDataPath=D:\google\Chrome_UserData"
set "FilePath=D:\google\Chrome_ShortCuts"
UserDataPath：每个 Chrome 实例的用户数据存储目录（每个多开账号的数据都放在这里）
FilePath：生成的快捷方式保存位置
✅ 建议改为本地磁盘路径，如：C:\Chrome_Profiles 或 %USERPROFILE%\Desktop\Shortcuts
2. Chrome 安装路径
bat
深色版本
set "TargetPath=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "WorkingDirectory=C:\Program Files\Google\Chrome\Application"
如果 Chrome 安装在其他位置，请修改为实际路径
3. 指纹参数池
bat
深色版本
set langs=en-US zh-CN fr-FR de-DE ja-JP
set sizes=1280,720 1366,768 1600,900 1920,1080
set uas="Mozilla/5.0 (Windows NT 10.0; Win64; x64) ..." "Macintosh ..." "Linux ..."
langs：支持的语言列表（影响网页语言和地区）
sizes：启动窗口尺寸（影响屏幕检测）
uas：User-Agent 列表，可伪装成 Windows、Mac、Linux 等系统
💡 参数会自动轮换使用，即使生成数量超过列表长度

4. 生成快捷方式数量
bat
深色版本
for /l %%i in (1,1,10) do (
将 10 改为你想要的数量，例如 5 生成 5 个，15 生成 15 个
▶️ 如何运行
右键脚本 → “以管理员身份运行”
脚本将自动：
创建文件夹
生成快捷方式
显示完成提示
去 Chrome_ShortCuts 文件夹点击任意快捷方式启动独立 Chrome 实例
⚠️ 注意事项
此脚本仅修改基础指纹，不能完全防止高级指纹检测（如 Canvas、WebGL、字体等）
多开 Chrome 会占用较多内存，请根据电脑性能合理设置数量
每个用户数据目录会占用几十 MB 到几百 MB 空间
若遇权限错误，请检查路径是否可写，或使用管理员模式运行
📄 许可证
MIT License - 可自由使用、修改、分享，欢迎 Fork！

💡 提示：适合用于跨境电商、社媒运营、测试开发等需要多账号管理的场景。



