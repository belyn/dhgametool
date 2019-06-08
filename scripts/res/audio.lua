-- Command line was: E:\github\dhgametool\scripts\res\audio.lua 

local audio = {}
require("common.const")
require("common.func")
local userdata = require("data.userdata")
local baseDir = "music/"
local ext = ".mp3"
audio.arena_bg = "arena_bg"
audio.fight_bg = {"fight_bg1", "fight_bg2"}
audio.ui_bg = "ui_bg"
audio.bag_sell_things = "ui/bag_sell_things"
audio.button = "ui/button"
audio.casino_1 = "ui/casino_1"
audio.casino_10 = "ui/casino_10"
audio.casino_get_common = "ui/casino_get_common"
audio.casino_get_nb = "ui/casino_get_nb"
audio.click_exp = "ui/click_exp"
audio.devour = "ui/devour"
audio.equip_forge = "ui/equip_forge"
audio.fight_lose = "ui/fight_lose"
audio.fight_start_button = "ui/fight_start_button"
audio.fight_win = "ui/fight_win"
audio.hero_advance = "ui/hero_advance"
audio.hero_equip_off = "ui/hero_equip_off"
audio.hero_equip_on = "ui/hero_equip_on"
audio.hero_lv_up = "ui/hero_lv_up"
audio.midas = "ui/midas"
audio.orange_merge = "ui/orange_merge"
audio.player_lv_up = "ui/player_lv_up"
audio.summon = "ui/summon"
audio.summon_get_common = "ui/summon_get_common"
audio.summon_get_nb = "ui/summon_get_nb"
audio.town_entry_arena = "ui/town_entry_arena"
audio.town_entry_blackmarket = "ui/town_entry_blackmarket"
audio.town_entry_casino = "ui/town_entry_casino"
audio.town_entry_devour = "ui/town_entry_devour"
audio.town_entry_smith = "ui/town_entry_smith"
audio.town_entry_summon = "ui/town_entry_summon"
audio.town_entry_tavern = "ui/town_entry_tavern"
audio.town_entry_trial = "ui/town_entry_trial"
audio.town_entry_worldmap = "ui/town_entry_worldmap"
audio.town_entry_heroforge = "ui/town_entry_heroforge"
audio.town_entry_airship = "ui/town_entry_airship"
audio.hero_forge = "ui/hero_forge"
audio.trial_chain = "ui/trial_chain"
audio.get_gold_exp = "ui/get_gold_exp"
audio.summon_reward = "ui/summon_reward"
audio.get_heart = "ui/get_heart"
audio.map_unlock = "ui/map_unlock"
audio.smith_forge = "ui/smith_forge"
audio.guild_skill_upgrade = "ui/guild_skill_upgrade"
audio.battle_card_reward = "ui/battle_card_reward"
audio.fire_1 = "ui/fire_1"
audio.fire_10 = "ui/fire_10"
local engine = SimpleAudioEngine:sharedEngine()
local backgroundEnabled = userdata.getBool(userdata.keys.musicBG, true)
audio.isBackgroundMusicEnabled = function()
  return backgroundEnabled
end

audio.setBackgroundMusicEnabled = function(l_2_0)
  if backgroundEnabled ~= l_2_0 then
    backgroundEnabled = l_2_0
    userdata.setBool(userdata.keys.musicBG, backgroundEnabled)
    if backgroundEnabled and not audio.isBackgroundMusicPlaying() then
      audio.playBackgroundMusic(audio.ui_bg)
    elseif not backgroundEnabled and audio.isBackgroundMusicPlaying() then
      audio.stopBackgroundMusic()
    end
  end
end

local effectEnabled = userdata.getBool(userdata.keys.musicFX, true)
audio.isEffectEnabled = function()
  return effectEnabled
end

audio.setEffectEnabled = function(l_4_0)
  if effectEnabled ~= l_4_0 then
    effectEnabled = l_4_0
    userdata.setBool(userdata.keys.musicFX, effectEnabled)
  end
end

audio.play = function(l_5_0)
  if effectEnabled then
    local fullname = baseDir .. l_5_0 .. ext
    engine:playEffect(fullname)
  end
end

audio.playAttack = function(l_6_0)
  if effectEnabled then
    local fullname = baseDir .. "ui/" .. l_6_0 .. ext
    engine:playEffect(fullname)
  end
end

audio.playSkill = function(l_7_0)
  if effectEnabled then
    local fullname = baseDir .. "skill/" .. l_7_0 .. ext
    engine:playEffect(fullname)
  end
end

audio.playHeroTalk = function(l_8_0)
  if effectEnabled then
    local lggStr = "us/"
    local lgg = require("res.i18n").getLanguageShortName()
    if lgg == "cn" or lgg == "tw" then
      lggStr = "cn/"
    end
    local fullname = baseDir .. "hero/" .. lggStr .. l_8_0
    audio.stopAllEffects()
    engine:playEffect(fullname)
  end
end

audio.playBackgroundMusic = function(l_9_0)
  if backgroundEnabled then
    if audio.isBackgroundMusicPlaying() then
      audio.stopBackgroundMusic()
    end
    local fullname = baseDir .. l_9_0 .. ext
    engine:playBackgroundMusic(fullname, true)
  end
end

audio.stopAllEffects = function()
  if effectEnabled then
    engine:stopAllEffects()
  end
end

audio.stopBackgroundMusic = function()
  engine:stopBackgroundMusic()
end

audio.pauseBackgroundMusic = function()
  if not backgroundEnabled then
    return 
  end
  if audio.isBackgroundMusicPlaying() then
    engine:pauseBackgroundMusic()
  end
end

audio.resumeBackgroundMusic = function()
  if not backgroundEnabled then
    return 
  end
  engine:resumeBackgroundMusic()
end

audio.isBackgroundMusicPlaying = function()
  return engine:isBackgroundMusicPlaying()
end

return audio

