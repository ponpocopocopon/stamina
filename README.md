# Stamina

よくゲームである、自動回復のポイント（以降スタミナと呼称）とかの実装

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stamina'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stamina

## Usage

スタミナは内部では時刻の形式で保持しているので、
datetime型が格納できる入れ物(カラムなど)を作ってあげます。

```ruby
 class User < ActiveRecord::Base
   include Stamina
   add_stamina_point :stamina
 end
````

スタミナを導入したいモデルにモジュールをincludeし、
add_stamina_point(引数はカラム等)を追加することで以下のようなメソッドが追加されます。
(staminaの部分はadd_stamina_pointで指定したものが入ります)

```ruby
max_stamina_point                        # 最大スタミナ(デフォルト: 100)
stamina_point_recovery_second            # 1回復に要する秒数(デフォルト: 5秒)
fill_stamina_point_second                # 完全回復に必要な秒数
stamina_point(nowtime = Time.current)    # 現在のスタミナ量
fill_stamina_point                       # スタミナ完全回復
fill_stamina_point?                      # スタミナ全快か？(return: true/false)
inc_stamina_point                        # スタミナを加える(return: 加算した量)
use_stamina_point                        # スタミナの使用(return: 成功[true]/スタミナ不足[false])
```

最大スタミナと1回復の秒数を変更する場合は、以下のようにインスタンスメソッドを上書きします。

```ruby
 class User < ActiveRecord::Base
   include Stamina
   add_stamina_point :stamina
   
   def max_stamina_point
     300
   end
   
   def stamina_point_recovery_second
     5
   end
 end
````

inc_stamina_pointやuse_stamina_pointなどは内部でsaveを行っていません。
回復と使用後は任意のタイミングで値を保存してください。

```ruby
  self.use_stamina_point 500
  self.save!
```

