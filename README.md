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
datetime型とかでカラムを作ってあげます。

```ruby
 class User < ActiveRecord::Base
   include Stamina
   add_stamina_point :stamina
````

スタミナを導入したいモデルにモジュールをincludeし、
add_stamina_point(引数はdatetime型のカラム名)を追加することで以下のメソッドが追加されます。

```ruby
max_[column]_point
max_[column]_point
max_[column]_point
max_[column]_point
max_[column]_point



```


 end
