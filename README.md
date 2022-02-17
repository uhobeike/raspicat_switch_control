# raspicat_switch_control

![パッケージ概要](https://user-images.githubusercontent.com/40545422/154504077-442f0179-f9c4-4433-bbe0-2bfc00d2c6c3.png)

# パッケージ概要
Raspberry Pi Catに搭載されているRaspberry Piのみでナビゲーションを行う際に、スイッチ(SW{0,1,2})を使用し、あらゆる操作行うためのパッケージです。

# 詳細
|      | LEDの点灯について                  | 
| ---- | -------------------------------- | 
| LED0 | ros masterのプロセスが走っている | 
| LED1 | SW0.shの処理が実行中なのか       | 
| LED2 | SW1.shの処理が実行中なのか       | 
| LED3 | SW2.shの処理が実行中なのか       | 

|     | スイッチ(SW{0,1,2})を押した場合について   | 
| --- | --------------------------- | 
| SW0 | SW0.shの処理の{実行,終了}   | 
| SW1 | SW1.shの処理の{実行,終了}   | 
| SW2 | SW2.shの処理の{実行,終了}   | 

# 使い方

サービスファイルのコピー
```
sudo cp raspicat_switch_control.service /etc/systemd/system
```

systemdに追加したファイルを反映
```
sudo systemctl daemon-reload
```

自動起動の有効化(起動時に実行されるようになる)
```
sudo systemctl enable raspicat_switch_control.service
```

サービスのスタート
```
sudo systemctl start raspicat_switch_control.service
```

# 使用例

例えば、`SW0をnavigationの立ち上げ`、`SW1をwaypoint_navigationのスタート`、`SW2をrosbagの記録`とした場合、以下のようになる。

他に実装したい機能があれば、SW{0,1,2}.shをそれぞれ編集してください。

```mermaid
sequenceDiagram
    Note over　操作者: navigationの立ち上げ
    操作者->> スイッチ(raspicat_switch_control.sh): navigation、センサーの立ち上げをやるで！SW0をポチッと
    スイッチ(raspicat_switch_control.sh)->> ロボット: SW0が押されたからSW0.shを実行するで！
    ロボット-->>操作者: SW0.shが実行されたから左から2番目のLEDを光らせるで！ナビゲーションの立ち上げ完了や！
    
    Note over　操作者: rosbagの記録
    操作者->> スイッチ(raspicat_switch_control.sh): rosbagを記録したいから、SW2をポチッと
    スイッチ(raspicat_switch_control.sh)->> ロボット: SW2が押されたからSW2.shを実行するで！
    ロボット-->>操作者: SW2.shが実行されたから左から4番目のLEDを光らせるで！rosbag録るで！終わった時はもっかいSW2を押してな！
    
    Note over　操作者: waypoint_navigationのスタート
    操作者->> スイッチ(raspicat_switch_control.sh): ﾖｼ！準備万端！navigationをスタートさせたいから、SW1をポチッと
    スイッチ(raspicat_switch_control.sh)->> ロボット: SW1が押されたからSW1.shを実行するで！
    ロボット-->>操作者: SW1.shが実行されたから左から3番目のLEDを光らせるで！ナビゲーションのスタートや！
```
