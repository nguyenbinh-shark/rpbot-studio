RPBot Studio cho Linux (Ubuntu 24.04 trở lên, x86_64)

Cài cho người dùng hiện tại:
    ./install.sh              chép app vào ~/.local/share/rpbot-studio, thêm vào menu ứng dụng
    ./install.sh --uninstall  gỡ app

Có thể chạy thẳng ./RPBotStudio mà không cần cài.

Máy cần:
    ROS 2 Jazzy có RViz (sudo apt install ros-jazzy-desktop) và ssh
    SSH key đăng nhập được vào robot (đã chấp nhận host key một lần)
Bản Linux chạy ROS trực tiếp, không qua WSL. Cấu hình và log ở ~/.local/state/RPBotConsole.
Hướng dẫn đầy đủ: README.md trên GitHub của dự án.
