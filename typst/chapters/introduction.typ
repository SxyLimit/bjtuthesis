= 绪论

引言（或绪论）简要说明研究工作的目的、范围、相关领域的前人工作和知识空白、理论基础和分析、研究设想、研究方法和实验设计、预期结果和意义等。应言简意赅，不要与摘要雷同，不要成为摘要的注释。一般教科书中有的知识，在引言中不必赘述。

== 编译方式说明

=== 在 Overleaf 上编译

请注意以下事项：

- 请上传整个 `.zip` 压缩包。
- 不要删除 `.latexmkrc` 文件，Overleaf 会自动识别并使用 XeLaTeX 编译（你也可以手动设置为 XeLaTeX）。
- 在 `chapter` 文件夹下编辑你的各章节内容。

=== 在本地编译

请按照以下步骤操作：

- 打开主 `.tex` 文件，例如：`bjtuthesis.tex`。
- 进入：选项 → 设置 TexStudio → 构建，设置如下：
  - 默认编译器选择：`XeLaTeX`
  - 默认文献工具选择：`Biber`
- 点击工具栏绿色箭头“构建 & 查看”（或按 `F5`）。
- 如果文献未显示，点击顶部菜单“工具(T)” → “参考文献(B)”运行 Biber（或按 `F8`）。
- 然后运行 XeLaTeX 两次，即点击两次“构建 & 查看”（`F5`）。

快捷方式：设置完成后，按顺序使用快捷键 `F5 - F8 - F5 - F5` 即可完整编译。

=== 在服务器（Linux）编译

建议使用 `Makefile`，集成了编译、清理中间文件、打开 PDF 三个步骤。

注意：使用 `Makefile` 时请勿修改主 `.tex` 文件名。

可用命令如下：

- `make`：等同于 `make all`，执行清理后编译 PDF。
- `make bjtuthesis`：仅编译 PDF。
- `make clean`：仅清理中间文件。
- `make view`：仅打开生成的 PDF。

== 统计字数脚本

模板提供了统计字数脚本，可在服务器或本地运行：

=== 使用 Bash 运行 `word_count.sh`

1. 打开终端（Windows 推荐使用 Git Bash 或 WSL + VS Code），切换到项目目录：

```
cd path\to\your\project
```

2. 执行脚本，传入主 `.tex` 文件名：

```
./scripts/word_count.sh bjtuthesis.tex
```

3. 输出说明：
   - 控制台显示简要统计信息；
   - 完整统计信息输出至：`outputs/bjtuthesis.wordcnt`。

=== 使用 PowerShell 运行 `word_count.ps1`

1. 打开终端，切换到项目目录：

```
cd path\to\your\project
```

2. 执行脚本，传入主 `.tex` 文件名：

```
./scripts/word_count.ps1 bjtuthesis.tex
```

3. 输出说明：
   - 控制台显示简要统计信息；
   - 完整统计信息输出至：`outputs/bjtuthesis.wordcnt`。
