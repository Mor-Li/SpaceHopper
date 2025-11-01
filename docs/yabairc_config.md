你可以根据你的 yabai 路径修改 sudoers 文件中的配置。按照你的路径，具体步骤如下：

1. 打开终端，输入以下命令来编辑 sudoers 文件：

   ```bash
   sudo visudo
   ```

2. 在文件末尾添加以下内容（假设你的用户名是 `limo`）：

   ```bash
   limo ALL=(ALL) NOPASSWD: /opt/homebrew/bin/yabai --load-sa
   ```

3. 保存并退出编辑器。

这样配置后，系统不会再要求你输入 sudo 密码来运行 `/opt/homebrew/bin/yabai --load-sa` 这个命令。

执行完这个步骤后，`sudo yabai --load-sa` 就可以在不提示密码的情况下运行了。