# PolygonLoadingRipper

我使用了 [这张地图](https://vrchat.com/home/world/wrld_057b9b0f-a9c1-4f3c-b002-058a658e2217) 作为调试目标，逆向工程了其中的Polygon Loading

![polygonloading](https://raw.githubusercontent.com/KeterTech/PolygonLoadingRipper/master/screenshots/VRChat_e6WbXY4pi1.png)

## 游戏内
![原模型](https://raw.githubusercontent.com/KeterTech/PolygonLoadingRipper/master/screenshots/VRChat_KGHca1eHDm.png)

## 转储之后
![截图](https://raw.githubusercontent.com/KeterTech/PolygonLoadingRipper/master/screenshots/blender_GWBcF6r26v.png)

## 修复之后(使用Poiyomi 8.0)
![修复之后](https://raw.githubusercontent.com/KeterTech/PolygonLoadingRipper/master/screenshots/Unity_6DRsoYuInv.png)

_可根据自己喜好酌情调整着色器设置_

# 功能
- 从模型文件中转储出对应的Mesh，Shader信息。
- 自动分组SubMesh(基本上是untiy的单个material)，并在material名字中附带shader名字。
- 转储Shader信息(x.bin.shaderinfo.txt)。
- 转储原始贴图内容，并生成转换脚本(需要Unity，见下文 贴图转换和导入)

# 使用方法
0. 克隆本库并(&&)从 Release 下载或(||)自行编译，确保本库中的`BinaryReader.exe`位于根目录。
1. 运行 request_list.bat 文件下载模型列表(你必须在电脑上拥有curl)。
2. 下载完毕之后会在运行目录下出现一个 ModelList.json 里面可能包含大量预览图数据(未证实)，你需要提取其中的json。(建议使用vscode，对于大文件有优化)
3. 在清理后的 ModelList.json 中找到你喜欢的模型，其中元素"tf"是该模型的文件名。
4. 从中仅复制ID(例如:691623fa5819625c6e5e)，然后编辑 request_model.bat 将其中第一行的 `set file=691623fa5819625c6e5e` 的等于号后面的ID更换为复制的ID。
5. 运行 request_model.bat 然后会在目录下下载得到对应的模型文件。
6. 运行 BinaryReader.exe 并且选择该文件。
7. 目录下应该会出现一个 x.bin.obj 文件，导入Blender或者Unity，你现在有了它。

`注意：本库中唯一包含的二进制文件为 gunzip 原版文件于(2007)年构建的版本，可以对比任何哈希。(https://sourceforge.net/projects/gnuwin32/)`

# 参考
`3b859834d2847b665c68_InfoString.json` 是在我创建该库的时候作者的模型 json 列表，里面注释了模型文件里面的json的各项所需参数 。

`3b859834d2847b665c68_InfoString_V8.json` 是我在最近 `2023/11/25` 有空回来更新这个库的时候，我重新标注的同样参数。

不过这基本上是一个梗，作者错误的认为只需要更改名字的含义就能混淆我，如果作者正在看这个库，注意：`不要尝试做这样愚蠢的行为，因为你不知道别人是否正在通过代码本身来确定一个变量的作用，而不是通过符号来确定变量的意思。`

# 贴图转换和导入
## 贴图转换
由于贴图具有Crunch压缩并且使用了DXT格式，我没能研究明白如何解压，我决定转变思路。

0. 在根据上述使用方法运行之后，你应该会在 .\Textures\ 目录下看到 texture_x.txt 的所有贴图文件，并且包含一个 TextureLoader.cs 脚本。
1. 运行 Unity ，打开任意项目。
2. 将 TextureLoader.cs 直接拖入 Unity编辑器 的资源窗口(默认在下方的 Project 选项卡中)。
3. 脚本是作为编辑器脚本导入的，导入之后应该会立即开始转换。
4. 查看 Console 选项卡，稍后应该会出现 `[PolygonRipper]` 为起头的日志输出，出现 `[PolygonRipper] Texture Converted!` 之后代表转换成功。
5. 回到 .\Textures\ 目录下，现在应该全部被转换为 .png 格式的图片。

## 贴图导入
如果你需要在3D软件中正确，完整的导入模型，很明显你需要直接知道材质(material)所需的贴图(texture)，因为自己一个一个试很麻烦。以下将以Unity为例子进行导入。

0. 根据前文中的内容，你应该有了模型Mesh以及完整的贴图，将其全部导入Unity。
1. 在 Unity 资源选项卡 中选择 .obj 的模型文件，在 Inspector 窗口中的 Materials 选项卡中查看 Remapped Materials
2. 其中的每个 material 的命名格式包含了一些信息，格式如下： `sm_id_shadername_tex_x-x-x` 其中 sm 为 submesh，id 为 导出时的顺序，shadername 为使用的着色器名字，tex 为对应的贴图id 然后紧跟着贴图id的编号，如果没有出现 `tex_x-x-x` 则代表这个 material 没有使用任何贴图。
3. 点击 Inspector 窗口中的 Extract Materials 将生成 material 并自动填充至模型。
4. 将贴图按照 material 名字中的 tex_x-x-x 编号设置。例如名字中的 tex_1-1-1 意味着导入了三次 texture_1 作为不同的shader属性贴图(尚未查明)。
5. 以此类推给所有 material 加入贴图并且正确的设置 shader。

你可以查看贴图本身来确定贴图的作用，根据我的测试，贴图中如果顺序为 1-2-1 之类的，很可能2号贴图是一个normal map

# 计划清单
- 去掉转换贴图对Unity的依赖，直接转储出png格式的贴图
- 转储重命名后的Json信息，可以帮助修复模型(x.bin.modelInfo.json)。 (编写中...) 可以通过阅读 3b859834d2847b665c68_InfoString.json 来知道这些json成员都代表什么意思

# 注意

由于这些模型都是提前预制的，所以它不能让你直接用在游戏中。

我制作这个只是出于爱好，我从中学到了不少3D知识，如果有任何问题请联系我。有关代码的问题请不要打扰，自己读代码。

mail@keter.tech
