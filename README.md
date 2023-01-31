# Actions-openwrt-build
- 参考 [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)。[P3TERX的博客](https://p3terx.com/)
- 自备梯子
- 在触发工作流程后，在 Actions 页面等待执行到`SSH connection to Actions`步骤，会出现下面信息：
  ***
  `To connect to this session copy-n-paste the following into a terminal or browser:`

  `ssh Y26QeagDtsPXp2mT6me5cnMRd@nyc1.tmate.io`

  `https://tmate.io/t/Y26QeagDtsPXp2mT6me5cnMRd`
  ***
- 复制 SSH 连接命令粘贴到终端内执行，或者复制链接在浏览器中打开使用网页终端，登陆云menuconfig
- 命令：`cd openwrt && make menuconfig`
- 如果此时页面没有反应，请ctrl+c
- 新手参考OpenWrt MenuConfig设置和LuCI插件选项说明
- 完成后按快捷键`Ctrl+D`或执行`exit`命令退出，后续编译工作将自动进行
- 这样比较灵活，可以根据路由器硬件通过云`menuconfig`自定义配置固件，不需要再导出`.config`和上传
