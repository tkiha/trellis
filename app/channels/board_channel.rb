# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class BoardChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'board_channel'
  end

  def unsubscribed
  end

  def board_subscribe(data)
    stop_all_streams
    stream_from "board_channel_#{data['id']}"
  end

  def move_card(data)
    card = current_user.cards.find(data['id'])
    BoardChannel.broadcast_card(card, :move)
  end

  def self.broadcast_card(card, action)
    ActionCable.server.broadcast "board_channel_#{card.board_id}", {dom: BoardChannel.build_card(card), card: card, action: action}
  end

  # クラスメソッドをプライベートにしてもクラス外から呼べるので、あまり意味が無いかなと思います。
  # クラス外から呼べないようにするなら  private_class_method を使うようにすればよさそうです。
  private
  def self.build_card(card)
    ApplicationController.renderer.render(partial: 'boards/card', locals: {card: card})
  end
end
