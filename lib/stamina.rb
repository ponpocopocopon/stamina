require "stamina/version"

module Stamina
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def add_stamina_point(c = :stamina)
      # 最大ポイント(デフォルト: 100)
      define_method "max_#{c}_point" do
        100
      end

      # 1秒あたりの回復値(デフォルト: 5)
      define_method "#{c}_point_recovery_second" do
        5
      end

      # 完全回復までの秒数
      define_method "fill_#{c}_point_second" do
        [self.send(c).to_i - Time.current.to_i, 0].max.ceil
      end

      # 現在のポイント
      define_method "#{c}_point", -> (nowtime = Time.current) do
        max_point             =  self.send("max_#{c}_point")
        point_recovery_second =  self.send("#{c}_point_recovery_second")
        self.send("#{c}=", nowtime) unless self.send(c)
        diff = [[(self.send(c).to_i - nowtime.to_i), 0].max, max_point * point_recovery_second].min
        point = max_point - (diff / point_recovery_second.to_f).ceil
        [[point, 0].max, max_point].min
      end

      # 全回復
      define_method "fill_#{c}_point" do
        self.send("#{c}=", Time.current)
      end

      # ポイントは完全回復状態か？(true/false)
      define_method "fill_#{c}_point?" do
        !!(self.send("#{c}_point") >= self.send("max_#{c}_point"))
      end

      # ポイントの回復(return: 回復量)
      define_method "inc_#{c}_point" do |value|
        before = self.send("#{c}_point")
        self.send("update_#{c}_at", value)
        self.send("#{c}_point") - before
      end

      # ポイントの使用(return: true(成功)/false(ポイント不足))
      define_method "use_#{c}_point" do |value|
        return false if self.send("#{c}_point") < value
        self.send("inc_#{c}_point", -value)
        true
      end

      # ポイントの更新
      define_method "update_#{c}_at" do |value|
        point_recovery_second = self.send("#{c}_point_recovery_second")
        now = Time.current
        org = self.send(c)
        dst = if value >= 0
          # 回復
          if self.send("fill_#{c}_point?")
            now
          else
            org - (value.abs * point_recovery_second)
          end
        else
          # 使用
          if org.to_i < now.to_i
            # MAX状態
            now + (value.abs * point_recovery_second)
          else
            # MAX状態未満
            org + (value.abs * point_recovery_second)
          end
        end
        self.send("#{c}=", dst)
      end
    end
  end
end
