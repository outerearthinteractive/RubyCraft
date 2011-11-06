module BetaPacket
  def BetaPacket.list
    {
      :keep_alive        => 0,
      :login_request      => 1,
      :handshake        => 2,
      :chat_message       => 3,
      :time_update      => 4,
      :entity_equip       => 5,
      :spawn_position     => 6,
      :use_entity       => 7,
      :update_health      => 8,
      :respawn        => 9,
      :player         => 10,
      :player_position    => 11,
      :player_look      => 12,
      :player_position_look   => 13,
      :player_dig       => 14,
      :player_place       => 15,
      :holding_change     => 16,
      :use_bed        => 17,
      :animation        => 18,
      :entity_action      => 19,
      :named_entity_spawn   => 20,
      :pickup_spawn       => 21,
      :collect_item       => 22,
      :add_object       => 23,
      :add_vehicle      => 23,
      :mob_spawn        => 24,
      :entity_painting    => 25,
      :experience_orb     => 26,
      :stance_update      => 27,
      :entity_velocity    => 28,
      :destroy_entity     => 29,
      :entity         => 30,
      :entity_relative_move => 31,
      :entity_look      => 32,
      :entity_look_relative_move => 33,
      :entity_teleport    => 34,
      :entity_status      => 38,
      :attach_entity      => 39,
      :entity_metadata    => 40,
      :entity_effect      => 41,
      :entity_effect_remove   => 42,
      :experience       => 43,
      :pre_chunk        => 50,
      :map_chunk        => 51,
      :block_change_multi   => 52,
      :block_change     => 53,
      :block_action     => 54,
      :explosion        => 60,
      :sound_effect     => 61,
      :new_state        => 70,
      :invalid_state      => 70,
      :thunderbolt      => 71,
      :window_open      => 100,
      :window_close     => 101,
      :window_click     => 102,
      :window_set_slot    => 103,
      :window_items     => 104,
      :update_progress_bar  => 105,
      :transaction      => 106,
      :creative_inventory_action => 107,
      :update_sign      => 130,
      :item_data        => 131,
      :increment_statistic  => 200,
      :player_list_item   => 201,
      :server_list_ping   => 254,
      :server_kick      => 255
    }
  end

  def BetaPacket.string16 message
    payload = BetaPacket.short(message.size)
    payload.concat(bytize(message))
    return payload
  end

  def BetaPacket.long message
    payload = [message].pack("q").unpack("C*")
    return payload
  end

  def BetaPacket.double message
    payload = [message].pack("d").unpack("C*")
    return payload
  end

  def BetaPacket.float message
    payload = [message].pack("f").unpack("C*")
    return payload
  end

  def BetaPacket.bool message
    payload = 0
    if message==true
      payload = 1
    end
    return [payload]
  end

  def BetaPacket.int message
    payload = [message].pack("l").unpack("C*")
    return payload
  end

  def BetaPacket.short message
    payload = [message].pack("S_").unpack("C*")
    return payload
  end

  def BetaPacket.byte message
    payload = [message].pack("c").unpack("C*")
    return payload
  end

  def BetaPacket.bytize message
    message_bytes = []
    message.each_byte do
      |b| message_bytes.push(b)
          message_bytes.push(0)
    end
    return message_bytes
  end

  def BetaPacket.string16len message
    message[0..1].pack("C*").unpack("S_")[0]
  end

  def BetaPacket.bisect array #Epic hack to fake utf16
    buffer = []
    array.each { |item|
      buffer.push item
      buffer.push 0
    }
    buffer.pop
    return buffer
  end

  def BetaPacket.debisect array
    buffer = []
    array.each do |item|
      if item != 0
        buffer.push item
      end
    end
    return buffer
  end

  def utfize string
    return string.force_encoding("UTF-16")
  end
end