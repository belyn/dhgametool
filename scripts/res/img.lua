-- Command line was: E:\github\dhgametool\scripts\res\img.lua 

local img = {}
require("common.const")
require("common.func")
local textureCache = CCTextureCache:sharedTextureCache()
local spriteframeCache = CCSpriteFrameCache:sharedSpriteFrameCache()
local baseDir = "images/"
local mapDir = "maps/"
local headDir = "head/"
local equipDir = "equip/"
local skinDir = "skin/"
local itemDir = "item/"
local skillDir = "skill/"
local gskillDir = "gskill/"
local gtechDir = "gtech/"
local gflagDir = "gflag/"
local buffDir = "buff/"
local hookmapDir = "hookmap/"
local vicemapDir = "vicemap/"
local loadingDir = "loading/"
local loginDir = "login/"
img.login = {login_logo = "login_logo.png", login_bar_fg = "login_bar_fg.png", login_bar_bg = "login_bar_bg.png", login_warning_bg = "login_warning_bg.png", login_warning_sentence = "login_warning_sentence.png", login_btn_qq = "login_btn_qq.png", login_btn_wx = "login_btn_wx.png", login_btn_visitor = "login_btn_visitor.png", wait_net = "wait_net.png", toast_bg = "toast_bg.png", tips_bg = "tips_bg.png", dialog = "dialog.png", dialog_pink = "dialog_pink.png", input_border = "input_border.png", text_border = "text_border.png", text_border_2 = "text_border_2.png", help_line = "help_line.png", button_9_gold = "button_9_gold.png", button_9_small_gold = "button_9_small_gold.png", button_9_small_green = "button_9_small_green.png", button_9_small_grey = "button_9_small_grey.png", button_9_small_mwhite = "button_9_small_mwhite.png", button_9_small_orange = "button_9_small_orange.png", button_9_small_pink = "button_9_small_pink.png", button_9_small_purple = "button_9_small_purple.png", button_9_buy = "button_9_buy.png", button_close = "button_close.png", login_btn_switch = "login_btn_switch.png", login_btn_repair = "login_btn_repair.png", login_btn_notice = "login_btn_notice.png", login_welcome_logo = "login_welcome_logo.png", login_welcome_bg = "login_welcome_bg.png", login_home_notice_board = "login_home_notice_board.png", login_home_protocol_board = "login_home_protocol_board.png", login_home_protocol_link = "login_home_user_protocol_link.png", login_home_start = "login_home_start.png", screen_border = "screen_border.png", guildFight_tick_bg = "guild_tick_bg.png", hook_btn_sel = "hook_btn_sel.png", login_home_protocol_open = "login_home_protocol_open.png", login_home_protocol_des = "login_home_protocol_des.png", home_ani_bg = "home_ani_bg.png", home_ani_caod = "home_ani_caod.png", home_ani_caol = "home_ani_caol.png", home_ani_caor = "home_ani_caor.png", home_ani_kulou = "home_ani_kulou.png", home_ani_man = "home_ani_man.png", home_ani_mo = "home_ani_mo.png", home_ani_wa = "home_ani_wa.png"}
local uiDir = "ui/"
img.ui = {clock = "clock.png", grid = "grid.png", back = "back.png", close = "close.png", bottom_border_2 = "bottom_border_2.png", btn_1 = "btn_1.png", btn_2 = "btn_2.png", btn_4 = "btn_4.png", btn_5 = "btn_5.png", btn_7 = "btn_7.png", btn_10 = "btn_10.png", btn_rank = "btn_rank.png", btn_help = "btn_help.png", btn_detail = "btn_detail.png", btn_preview = "btn_preview.png", btn_reset = "btn_reset.png", coin = "coin.png", gem = "gem.png", evolve = "evolve.png", reward_bottom = "reward_bottom.png", dialog_1 = "dialog_1.png", dialog_2 = "dialog_2.png", botton_fram_1 = "botton_fram_1.png", botton_fram_2 = "botton_fram_2.png", botton_fram_3 = "botton_fram_3.png", botton_fram_4 = "botton_fram_4.png", input_box = "input_box.png", btn_sub = "btn_sub.png", btn_add = "btn_add.png", btn_max = "btn_max.png", power_icon = "power_icon.png", crystal = "crystal.png", reward_bg = "reward_bg.png", item_yellow = "item_yellow.png", reward_frame = "reward_frame.png", levelup_lv_bg = "levelup_lv_bg.png", help_line = "help_line.png", head_bg = "head_bg.png", star = "star.png", star_s = "star_s.png", star_s_eq = "star_s_eq.png", Lock = "Lock.png", arrow = "arrow.png", split_line = "split_line.png", inner_bg = "inner_bg.png", job_1 = "job_1.png", job_2 = "job_2.png", job_3 = "job_3.png", job_4 = "job_4.png", job_5 = "job_5.png", hero_head_shade = "hero_head_shade.png", campbuff_none = "campbuff_none.png", campbuff_grid = "campbuff_grid.png", campbuff_slot = "campbuff_slot.png", vip_paper = "vip_paper.png", shop_board = "shop_board.png", shop_circle_dark = "shop_circle_dark.png", shop_circle_light = "shop_circle_light.png", hero_star_orange = "hero_star_orange.png", hero_star_ten = "hero_star_ten.png", hero_star_ten_bg = "hero_star_ten_bg.png", team_icon = "team_icon.png", pay_wx = "pay_wx.png", pay_ali = "pay_ali.png", reward = "reward.png", locked = "locked.png", option_bg = "option_bg.png", option_tick = "option_tick.png", btn_resume = "btn_resume.png", right_next = "right_next.png", icon_realname = "icon_realname.png", icon_lock = "icon_lock.png", loading_s = "loading_s.png", tips_bg = "tips_bg.png", tips_sell_add = "tips_sell_add.png", tips_sell_sub = "tips_sell_sub.png", tips_sell_coin_bg = "tips_sell_coin_bg.png", hero_forge_titlebg = "hero_forge_titlebg.png", hero_forge_inner = "hero_forge_inner.png", hero_forge_bg = "hero_forge_bg.png", hero_bg = "hero_bg.png", hero_bg1 = "hero_bg1.png", hero_bg2 = "hero_bg2.png", hero_bg3 = "hero_bg3.png", hero_bg4 = "hero_bg4.png", hero_bg5 = "hero_bg5.png", hero_bg6 = "hero_bg6.png", hero_attr_atk = "hero_attr_atk.png", hero_attr_def = "hero_attr_def.png", hero_attr_hp = "hero_attr_hp.png", hero_attr_spd = "hero_attr_spd.png", hero_attribute_lab_frame = "hero_attribute_lab_frame.png", hero_btn_ehchant0 = "hero_btn_ehchant0.png", hero_btn_ehchant1 = "hero_btn_ehchant1.png", hero_btn_equip_nselect = "hero_btn_equip_nselect.png", hero_btn_equip_select = "hero_btn_equip_select.png", hero_btn_info_nselect = "hero_btn_info_nselect.png", hero_btn_info_select = "hero_btn_info_select.png", hero_btn_karma_nselect = "hero_btn_karma_nselect.png", hero_btn_karma_select = "hero_btn_karma_select.png", hero_btn_lvup = "hero_btn_lvup.png", hero_circle_bg = "hero_circle_bg.png", hero_enchant_cost_bg = "hero_enchant_cost_bg.png", hero_enchant_fgline = "hero_enchant_fgline.png", hero_enchant_info_fgline = "hero_enchant_info_fgline.png", hero_enchant_select = "hero_enchant_select.png", hero_equip_lab_frame = "hero_equip_lab_frame.png", hero_evolve_cost_bg = "hero_evolve_cost_bg.png", hero_group_bg = "hero_group_bg.png", hero_icon_bg = "hero_icon_bg.png", hero_lock = "hero_lock.png", hero_lv_cost_bg = "hero_lv_cost_bg.png", hero_maxlv = "hero_maxlv.png", hero_maxlv_cn = "hero_maxlv_cn.png", hero_maxlv_tw = "hero_maxlv_tw.png", hero_maxlv_jp = "hero_maxlv_jp.png", hero_maxlv_ru = "hero_maxlv_ru.png", hero_maxlv_kr = "hero_maxlv_kr.png", hero_panel_fgline = "hero_panel_fgline.png", hero_pedestal = "hero_pedestal.png", hero_progress_bg = "hero_progress_bg.png", hero_skill_bg = "hero_skill_bg.png", hero_star0 = "hero_star0.png", hero_star1 = "hero_star1.png", hero_tips_fgline = "hero_tips_fgline.png", hero_unlock = "hero_unlock.png", hero_evolve_bg = "hero_evolve_bg.png", hero_equip_add = "hero_equip_add.png", hero_equip_icon1 = "hero_equip_icon1.png", hero_equip_icon2 = "hero_equip_icon2.png", hero_equip_icon3 = "hero_equip_icon3.png", hero_equip_icon4 = "hero_equip_icon4.png", hero_equip_icon5 = "hero_equip_icon5.png", hero_equip_crystal = "hero_equip_crystal.png", hero_equip_bg = "hero_equip_bg.png", hero_btn_share = "hero_btn_share.png", hero_up_bottom = "hero_up_bottom.png", hero_btn_up_nselect = "hero_btn_up_nselect.png", hero_btn_up_select = "hero_btn_up_select.png", hero_up_line = "hero_up_line.png", hero_up_nstar = "hero_up_nstar.png", hero_up_titlebg = "hero_up_titlebg.png", hero_btn_raw = "hero_btn_raw.png", hero_up_line_deep = "hero_up_line_deep.png", hero_skilllevel_bg = "hero_skilllevel_bg.png", hero_raw = "hero_raw.png", hero_btn_skin_nselect = "hero_btn_skin_nselect.png", hero_btn_skin_select = "hero_btn_skin_select.png", hero_skin_pointer = "hero_skin_pointer.png", hero_treasure_board = "hero_treasure_board.png", hero_skin_visit0 = "hero_skin_visit0.png", hero_skin_visit1 = "hero_skin_visit1.png", hero_energize_flower = "hero_energize_flower.png", hero_energize_skillbtn = "hero_energize_skillbtn.png", hero_energize_fazhen = "hero_energize_fazhen.png", hero_enegy_btn = "hero_enegy_btn.png", hero_trans_btn = "hero_trans_btn.png", arena_bg = "arena_bg.png", arena_button_video = "arena_button_video.png", arena_daily_bg = "arena_daily_bg.png", fight_hurts_new_line = "fight_hurts_new_line.png", arena_defen_icon = "arena_defen_icon.png", arena_frame1 = "arena_frame1.png", arena_frame2 = "arena_frame2.png", arena_frame3 = "arena_frame3.png", arena_frame4 = "arena_frame4.png", arena_frame5 = "arena_frame5.png", arena_frame6 = "arena_frame6.png", arena_frame7 = "arena_frame7.png", arena_icon_lost = "arena_icon_lost.png", arena_icon_win = "arena_icon_win.png", arena_pickrival_frame = "arena_pickrival_frame.png", arena_rank_1 = "arena_rank_1.png", arena_rank_2 = "arena_rank_2.png", arena_rank_3 = "arena_rank_3.png", arena_record_icon = "arena_record_icon.png", arena_reward_icon = "arena_reward_icon.png", arena_season_bg = "arena_season_bg.png", arena_select = "arena_select.png", arena_ticket_bg = "arena_ticket_bg.png", arena_triangle = "arena_triangle.png", arena_daily_btn0 = "arena_daily_btn0.png", arena_daily_btn1 = "arena_daily_btn1.png", arena_season_btn0 = "arena_season_btn0.png", arena_season_btn1 = "arena_season_btn1.png", anrea_entrance_bg1 = "anrea_entrance_bg1.png", anrea_entrance_bg2 = "anrea_entrance_bg2.png", anrea_entrance_bg3 = "anrea_entrance_bg3.png", anrea_entrance_shop = "anrea_entrance_shop.png", arena_new_video_bg_lose = "arena_new_video_bg_lose.png", arena_new_video_bg_win = "arena_new_video_bg_win.png", arena_new_video_btn = "arena_new_video_btn.png", arena_new_vs = "arena_new_vs.png", arena_new_adorn = "arena_new_adorn.png", arena_new_question = "arena_new_question.png", arena_new_shop_up_bar = "arena_new_shop_up_bar.png", arena_new_shop_icon = "arena_new_shop_icon.png", arena_new_switch = "arena_new_switch.png", arena_new_cancel_icon = "arena_new_cancel_icon.png", arena_new_change_icon = "arena_new_change_icon.png", anrea_server_bg = "anrea_server_bg.png", brave_bg = "brave_bg.png", brave_bg_frame = "brave_bg_frame.png", brave_boss_bg = "brave_boss_bg.png", brave_btn_fight0 = "brave_btn_fight0.png", brave_btn_fight00 = "brave_btn_fight00.png", brave_btn_fight1 = "brave_btn_fight1.png", brave_decoration = "brave_decoration.png", brave_first_bg = "brave_first_bg.png", brave_fort_0 = "brave_fort_0.png", brave_fort_1 = "brave_fort_1.png", brave_fort_2 = "brave_fort_2.png", brave_fort3 = "brave_fort3.png", brave_reward_icon = "brave_reward_icon.png", brave_shoot_bg = "brave_shoot_bg.png", brave_team_icon = "brave_team_icon.png", brave_store_icon = "brave_store_icon.png", brave_shop_top = "brave_shop_top.png", brave_level_battalbo = "brave_level_battalbo.png", brave_level_circle = "brave_level_circle.png", brave_level_exppro = "brave_level_exppro.png", brave_level_raw = "brave_level_raw.png", brave_level_expbg = "brave_level_expbg.png", brave_rl_black = "brave_rl_black.png", brave_shopbg = "brave_shopbg.png", brave_title = "brave_title.png", main_btn_shop = "main_btn_shop.png", main_icon_bg = "main_icon_bg.png", main_icon_bag = "main_icon_bag.png", main_icon_bubble = "main_icon_bubble.png", main_icon_feats = "main_icon_feats.png", main_icon_fold = "main_icon_fold.png", main_icon_guide = "main_icon_guide.png", main_icon_guild = "main_icon_guild.png", main_icon_hero = "main_icon_hero.png", main_icon_pet = "main_icon_pet.png", main_icon_mail = "main_icon_mail.png", main_icon_feed = "main_icon_feed.png", main_icon_plus = "main_icon_plus.png", main_icon_setting = "main_icon_setting.png", main_icon_task = "main_icon_task.png", main_icon_online = "main_icon_online.png", main_icon_firstpay = "main_icon_firstpay.png", main_icon_monthlyact = "main_icon_monthlyact.png", main_icon_vip = "main_icon_vip.png", main_lv_pgb_fg = "main_lv_pgb_fg.png", main_player_bg = "main_player_bg.png", main_msg_bg = "main_msg_bg.png", main_coin_bg = "main_coin_bg.png", main_btn_shop_bg = "main_btn_shop_bg.png", main_icon_activity = "main_icon_activity.png", main_icon_friend = "main_icon_friend.png", main_icon_reward = "main_icon_reward.png", main_icon_challenge = "main_icon_challenge.png", main_icon_limit = "main_icon_limit.png", main_icon_video = "main_icon_video.png", main_lt = "main_lt.png", main_lv_bg = "main_lv_bg.png", main_rt = "main_rt.png", main_red_dot = "main_red_dot.png", main_vip_bg = "main_vip_bg.png", main_building_lbl = "main_building_lbl.png", main_mask_topL = "main_mask_topL.png", main_mask_bottom = "main_mask_bottom.png", main_list_bg = "main_list_bg.png", main_btn_fold = "main_btn_fold.png", main_btn_unfold = "main_btn_unfold.png", main_icon_skin = "main_icon_skin.png", headbox_1 = "headbox_1.png", headbox_2 = "headbox_2.png", headbox_3 = "headbox_3.png", headbox_4 = "headbox_4.png", headbox_5 = "headbox_5.png", fight_hp_bg = {small = "fight_hp_bg.png", large = "fight_hp_boss_bg.png"}, fight_hp_fg = {small = "fight_hp_fg.png", large = "fight_hp_boss_fg.png"}, fight_hp_fx = {small = "fight_hp_fx.png", large = "fight_hp_boss_fx.png"}, fight_ep_bg = {small = "fight_ep_bg.png", large = "fight_ep_boss_bg.png"}, fight_ep_fg = {small = "fight_ep_fg.png", large = "fight_ep_boss_fg.png"}, fight_ep_full = {small = "fight_ep_full.png", large = "fight_ep_boss_full.png"}, fight_miss = "fight_miss.png", fight_miss_cn = "fight_miss_cn.png", fight_miss_de = "fight_miss_de.png", fight_miss_fr = "fight_miss_fr.png", fight_miss_jp = "fight_miss_jp.png", fight_miss_kr = "fight_miss_kr.png", fight_miss_pt = "fight_miss_pt.png", fight_miss_ru = "fight_miss_ru.png", fight_miss_tw = "fight_miss_tw.png", fight_miss_us = "fight_miss_us.png", fight_immune = "fight_immune.png", fight_skip = "fight_skip.png", fight_speed_up = "fight_speed_up.png", fight_pay_bg_win = "fight_pay_bg_win.png", fight_pay_bg_lose = "fight_pay_bg_lose.png", fight_pay_vs = "fight_pay_vs.png", fight_pay_go_hero = "fight_pay_go_hero.png", fight_pay_go_smith = "fight_pay_go_smith.png", fight_pay_go_summon = "fight_pay_go_summon.png", fight_hurts = "fight_hurts.png", fight_hurts_bg_1 = "fight_hurts_bg_1.png", fight_hurts_bg_2 = "fight_hurts_bg_2.png", fight_hurts_bar_bg = "fight_hurts_bar_bg.png", fight_hurts_bar_fg_1 = "fight_hurts_bar_fg_1.png", fight_hurts_bar_fg_2 = "fight_hurts_bar_fg_2.png", fight_hurts_line = "fight_hurts_line.png", fight_group_help = "fight_group_help.png", fight_group_1 = "fight_group_1.png", fight_group_2 = "fight_group_2.png", fight_group_3 = "fight_group_3.png", fight_group_4 = "fight_group_4.png", fight_group_5 = "fight_group_5.png", fight_group_6 = "fight_group_6.png", fight_normal_num_minus = "fight_normal_num_minus.png", fight_normal_num_0 = "fight_normal_num_0.png", fight_normal_num_1 = "fight_normal_num_1.png", fight_normal_num_2 = "fight_normal_num_2.png", fight_normal_num_3 = "fight_normal_num_3.png", fight_normal_num_4 = "fight_normal_num_4.png", fight_normal_num_5 = "fight_normal_num_5.png", fight_normal_num_6 = "fight_normal_num_6.png", fight_normal_num_7 = "fight_normal_num_7.png", fight_normal_num_8 = "fight_normal_num_8.png", fight_normal_num_9 = "fight_normal_num_9.png", fight_damage_num_minus = "fight_damage_num_minus.png", fight_damage_num_0 = "fight_damage_num_0.png", fight_damage_num_1 = "fight_damage_num_1.png", fight_damage_num_2 = "fight_damage_num_2.png", fight_damage_num_3 = "fight_damage_num_3.png", fight_damage_num_4 = "fight_damage_num_4.png", fight_damage_num_5 = "fight_damage_num_5.png", fight_damage_num_6 = "fight_damage_num_6.png", fight_damage_num_7 = "fight_damage_num_7.png", fight_damage_num_8 = "fight_damage_num_8.png", fight_damage_num_9 = "fight_damage_num_9.png", fight_crit_num_minus = "fight_crit_num_minus.png", fight_crit_num_0 = "fight_crit_num_0.png", fight_crit_num_1 = "fight_crit_num_1.png", fight_crit_num_2 = "fight_crit_num_2.png", fight_crit_num_3 = "fight_crit_num_3.png", fight_crit_num_4 = "fight_crit_num_4.png", fight_crit_num_5 = "fight_crit_num_5.png", fight_crit_num_6 = "fight_crit_num_6.png", fight_crit_num_7 = "fight_crit_num_7.png", fight_crit_num_8 = "fight_crit_num_8.png", fight_crit_num_9 = "fight_crit_num_9.png", fight_heal_num_add = "fight_heal_num_add.png", fight_heal_num_0 = "fight_heal_num_0.png", fight_heal_num_1 = "fight_heal_num_1.png", fight_heal_num_2 = "fight_heal_num_2.png", fight_heal_num_3 = "fight_heal_num_3.png", fight_heal_num_4 = "fight_heal_num_4.png", fight_heal_num_5 = "fight_heal_num_5.png", fight_heal_num_6 = "fight_heal_num_6.png", fight_heal_num_7 = "fight_heal_num_7.png", fight_heal_num_8 = "fight_heal_num_8.png", fight_heal_num_9 = "fight_heal_num_9.png", fight_top_banner = "fight_top_banner.png", fight_pet_ep_bg = "fight_pet_ep_bg.png", fight_pet_ep_fg = "fight_pet_ep_fg.png", fight_load_bar_fg = "fight_load_bar_fg.png", fight_load_bar_bg = "fight_load_bar_bg.png", fight_load_bar_light = "fight_load_bar_light.png", fight_load_1_bg = "fight_load_1_bg.png", fight_load_1_fg = "fight_load_1_fg.png", fight_load_2_bg = "fight_load_2_bg.png", fight_load_2_box = "fight_load_2_box.png", achieve_calim = "achieve_calim.png", achieve_decoration = "achieve_decoration.png", achieve_progress_fg = "achieve_progress_fg.png", gemstore_bg = "gemstore_bg.png", gemstore_blue_icon = "gemstore_blue_icon.png", gemstore_green_icon = "gemstore_green_icon.png", gemstore_decoration = "gemstore_decoration.png", gemstore_double_icon = "gemstore_double_icon.png", gemstore_double_icon_cn = "gemstore_double_icon_cn.png", gemstore_double_icon_tw = "gemstore_double_icon_tw.png", gemstore_double_icon_jp = "gemstore_double_icon_jp.png", gemstore_double_icon_ru = "gemstore_double_icon_ru.png", gemstore_double_icon_kr = "gemstore_double_icon_kr.png", gemstore_double_icon_sp = "gemstore_double_icon_sp.png", gemstore_double_icon_pt = "gemstore_double_icon_pt.png", gemstore_double_icon_tr = "gemstore_double_icon_tr.png", gemstore_extra_icon = "gemstore_extra_icon.png", gemstore_fgline = "gemstore_fgline.png", gemstore_item_bg = "gemstore_item_bg.png", gemstore_item0 = "gemstore_item0.png", gemstore_item1 = "gemstore_item1.png", gemstore_item2 = "gemstore_item2.png", gemstore_item3 = "gemstore_item3.png", gemstore_item4 = "gemstore_item4.png", gemstore_item5 = "gemstore_item5.png", gemstore_item6 = "gemstore_item6.png", gemstore_item7 = "gemstore_item7.png", gemstore_next_icon0 = "gemstore_next_icon0.png", gemstore_next_icon1 = "gemstore_next_icon1.png", gemstore_point = "gemstore_point.png", gemstore_vip_all_bg = "gemstore_vip_all_bg.png", gemstore_vip_bg = "gemstore_vip_bg.png", gemstore_vip_fg = "gemstore_vip_fg.png", gemstore_monblack = "gemstore_monblack.png", herotask_bg = "herotask_bg.png", herotask_add_icon = "herotask_add_icon.png", herotask_complete_dg = "herotask_complete_dg.png", herotask_fgline = "herotask_fgline.png", herotask_hero_work = "herotask_hero_work.png", herotask_time_shortfg = "herotask_time_shortfg.png", herotask_job_1 = "herotask_job_1.png", herotask_job_2 = "herotask_job_2.png", herotask_job_3 = "herotask_job_3.png", herotask_job_4 = "herotask_job_4.png", herotask_job_5 = "herotask_job_5.png", herotask_dialog = "herotask_dialog.png", herotask_font = "herotask_font.png", herotask_time_bar = "herotask_time_bar.png", herotask_time_finish = "herotask_time_finish.png", hero_task_1 = "hero_task_1.png", hero_task_2 = "hero_task_2.png", hero_task_3 = "hero_task_3.png", hero_task_4 = "hero_task_4.png", hero_task_5 = "hero_task_5.png", hero_task_6 = "hero_task_6.png", hero_task_7 = "hero_task_7.png", herotask_task_bg = "herotask_task_bg.png", select_hero_buff_bg = "select_hero_buff_bg.png", select_hero_camp_bg = "select_hero_camp_bg.png", select_tab_tab_bg = "select_tab_tab_bg.png", select_hero_hero_bg = "select_hero_hero_bg.png", select_hero_power_bg = "select_hero_power_bg.png", select_tab_btn_unselect = "select_tab_btn_unselect.png", select_hero_btn_icon = "select_hero_btn_icon.png", dreamland_fgline = "dreamland_fgline.png", dreamland_level_bg = "dreamland_level_bg.png", dreamland_stage_bg = "dreamland_stage_bg.png", dreamland_lasttime_bg = "dreamland_lasttime_bg.png", summon_bg = "summon_bg.png", summon_helmet0 = "summon_helmet0.png", summon_power_bar = "summon_power_bar.png", summon_power_gauge = "summon_power_gauge.png", summon_item1 = "summon_item1.png", summon_item2 = "summon_item2.png", summon_blue_bg = "summon_blue_bg.png", summon_purple_bg = "summon_purple_bg.png", summon_red_bg = "summon_red_bg.png", herolist_bg = "herolist_bg.png", herolist_button_pulldown = "herolist_button_pulldown.png", herolist_group_1 = "herolist_group_1.png", herolist_group_2 = "herolist_group_2.png", herolist_group_3 = "herolist_group_3.png", herolist_group_4 = "herolist_group_4.png", herolist_group_5 = "herolist_group_5.png", herolist_group_6 = "herolist_group_6.png", herolist_group_bg = "herolist_group_bg.png", herolist_head_bg = "herolist_head_bg.png", herolist_pulldown = "herolist_pulldown.png", herolist_select_icon = "herolist_select_icon.png", herolist_star = "herolist_star.png", herolist_tab_book_nselect = "herolist_tab_book_nselect.png", herolist_tab_book_select = "herolist_tab_book_select.png", herolist_tab_hero_nselect = "herolist_tab_hero_nselect.png", herolist_tab_hero_select = "herolist_tab_hero_select.png", herolist_triangle = "herolist_triangle.png", herolist_withouthero_bg = "herolist_withouthero_bg.png", bag_bg = "bag_bg.png", bag_btn_blue = "bag_btn_blue.png", bag_btn_green = "bag_btn_green.png", bag_btn_purple = "bag_btn_purple.png", bag_btn_red = "bag_btn_red.png", bag_btn_yellow = "bag_btn_yellow.png", bag_btn_orange = "bag_btn_orange.png", bag_btn_inner_bg = "bag_btn_inner_bg.png", bag_outer_bg = "bag_outer_bg.png", bag_dianji = "bag_dianji.png", bag_tab_equip0 = "bag_tab_equip_0.png", bag_tab_equip1 = "bag_tab_equip_1.png", bag_tab_piece0 = "bag_tab_piece_0.png", bag_tab_piece1 = "bag_tab_piece_1.png", bag_tab_item0 = "bag_tab_item_0.png", bag_tab_item1 = "bag_tab_item_1.png", bag_tab_equippiece_0 = "bag_tab_equippiece_0.png", bag_tab_equippiece_1 = "bag_tab_equippiece_1.png", bag_grid_selected = "bag_grid_selected.png", bag_piece = "bag_piece.png", bag_heropiece_progr_0 = "bag_heropiece_progr_0.png", bag_heropiece_progr_1 = "bag_heropiece_progr_1.png", bag_heropiece_progr = "bag_heropiece_progr.png", bag_outer = "bag_outer.png", bag_inner = "bag_inner.png", bag_tab_treasure_0 = "bag_tab_treasure_0.png", bag_tab_treasure_1 = "bag_tab_treasure_1.png", bag_icon_getway = "bag_icon_getway.png", bag_btn_shenqi = "bag_btn_shenqi.png", equip_qlt_bg_1 = "equip_qlt_bg_1.png", equip_qlt_bg_2 = "equip_qlt_bg_2.png", equip_qlt_bg_3 = "equip_qlt_bg_3.png", equip_qlt_bg_4 = "equip_qlt_bg_4.png", equip_qlt_bg_5 = "equip_qlt_bg_5.png", equip_qlt_bg_6 = "equip_qlt_bg_6.png", equip_job_bg = "equip_job_bg.png", devour_bg = "devour_bg.png", rune_store = "rune_store.png", devour_add_icon = "devour_add_icon.png", devour_btn_smart = "devour_btn_smart.png", devour_circle_bg = "devour_circle_bg.png", devour_icon_lock = "devour_icon_lock.png", devour_lef_bg = "devour_lef_bg.png", devour_find = "devour_find.png", devour_lef_title = "devour_lef_title.png", playerInfo_exp_bg = "playerInfo_exp_bg.png", playerInfo_button_change = "playerInfo_button_change.png", playerInfo_info_bg = "playerInfo_info_bg.png", playerInfo_name_bg = "playerInfo_name_bg.png", playerInfo_process_bar_bg = "playerInfo_process_bar_bg.png", playerInfo_process_bar_fg = "playerInfo_process_bar_fg.png", mail_board = "mail_board.png", mail_btn_close = "mail_btn_close.png", mail_btn_inbox = "mail_btn_inbox.png", mail_btn_inbox_hl = "mail_btn_inbox_hl.png", mail_btn_new = "mail_btn_new.png", mail_btn_new_hl = "mail_btn_new_hl.png", mail_btn_sys = "mail_btn_sys.png", mail_btn_sys_hl = "mail_btn_sys_hl.png", mail_content_bg = "mail_content_bg.png", mail_content_split = "mail_content_split.png", mail_icon = "mail_icon.png", mail_icon_read = "mail_icon_read.png", mail_icon_gift = "mail_icon_gift.png", mail_icon_gift_read = "mail_icon_gift_read.png", mail_icon_nomail = "mail_icon_nomail.png", mail_icon_del = "mail_icon_del.png", mail_item = "mail_item.png", mail_item_hl = "mail_item_hl.png", mail_item_read = "mail_item_read.png", mail_lbl_bg = "mail_lbl_bg.png", mail_list_bg = "mail_list_bg.png", mail_new_bg = "mail_new_bg.png", mail_icon_got = "mail_icon_got.png", midas_titlebg = "midas_titlebg.png", midas_clock = "midas_clock.png", midas_diamond_gray = "midas_diamond_gray.png", midas_icon_1 = "midas_icon_1.png", midas_icon_2 = "midas_icon_2.png", midas_icon_3 = "midas_icon_3.png", midas_titlebg_crst = "midas_titlebg_crst.png", midas_icon_4 = "midas_icon_4.png", midas_icon_5 = "midas_icon_5.png", midas_icon_6 = "midas_icon_6.png", midas_person = "midas_person.png", midas_icon_bottom1 = "midas_icon_bottom1.png", midas_icon_bottom2 = "midas_icon_bottom2.png", chat_bg = "chat_bg.png", chat_board = "chat_board.png", chat_btn_close = "chat_btn_close.png", chat_btn_send = "chat_btn_send.png", chat_bubble = "chat_bubble.png", chat_bubble_arrow = "chat_bubble_arrow.png", chat_icon_vip_g = "chat_icon_vip_g.png", chat_icon_vip_s = "chat_icon_vip_s.png", chat_icon_vip_c = "chat_icon_vip_c.png", chat_btn_trans = "chat_btn_trans.png", player_addfrd = "player_addfrd.png", player_block = "player_block.png", player_deletefrd = "player_deletefrd.png", player_report = "player_report.png", player_sendmail = "player_sendmail.png", blackmarket_bg = "blackmarket_bg.png", blackmarket_btn_buy = "blackmarket_btn_buy.png", blackmarket_btn_refresh = "blackmarket_btn_refresh.png", blackmarket_shadow = "blackmarket_shadow.png", blackmarket_soldout = "blackmarket_soldout.png", blackmarket_clock = "blackmarket_clock.png", blackmarket_limittag = "blackmarket_limittag.png", friends_circle_botton = "friends_circle_botton.png", friends_gift_1 = "friends_gift_1.png", friends_refresh = "friends_refresh.png", friends_tab_list_0 = "friends_tab_list_0.png", friends_tab_list_1 = "friends_tab_list_1.png", friends_tab_query_0 = "friends_tab_query_0.png", friends_tab_query_1 = "friends_tab_query_1.png", friends_tab_req_0 = "friends_tab_req_0.png", friends_tab_req_1 = "friends_tab_req_1.png", friends_tab_help_0 = "friends_tab_help_0.png", friends_tab_help_1 = "friends_tab_help_1.png", friends_tick = "friends_tick.png", friends_x = "friends_x.png", friends_search = "friends_search.png", friends_boss_btn = "friends_boss_btn.png", friends_boss_blood = "friends_boss_blood.png", friends_enegy = "friends_enegy.png", friends_btn_fight = "friends_btn_fight.png", friends_zhezhao = "friends_zhezhao.png", friends_fight = "friends_fight.png", hook_btn_add = "hook_btn_add.png", hook_btn_battle = "hook_btn_battle.png", hook_btn_cd_bg = "hook_btn_cd_bg.png", hook_btn_cd_fg = "hook_btn_cd_fg.png", hook_btn_battle_cd = "hook_btn_battle_cd.png", hook_btn_battle_pass = "hook_btn_battle_pass.png", hook_btn_drops = "hook_btn_drops.png", hook_btn_hook_anim1 = "hook_btn_hook_anim1.png", hook_btn_hook_anim2 = "hook_btn_hook_anim2.png", hook_btn_lock = "hook_btn_lock.png", hook_btn_mask = "hook_btn_mask.png", hook_btn_rewards = "hook_btn_rewards.png", hook_btn_sel = "hook_btn_sel.png", hook_btn_stage_bg = "hook_btn_stage_bg.png", hook_bubble = "hook_bubble.png", hook_bubble_arrow = "hook_bubble_arrow.png", hook_icon_bag = "hook_icon_bag.png", hook_icon_hero = "hook_icon_hero.png", hook_icon_hero_xp = "hook_icon_hero_xp.png", hook_icon_map = "hook_icon_map.png", hook_icon_player_xp = "hook_icon_player_xp.png", hook_icon_team = "hook_icon_team.png", hook_icon_lock = "hook_icon_lock.png", hook_icon_reward = "hook_icon_reward.png", hook_pgb_bg = "hook_pgb_bg.png", hook_pgb_fg = "hook_pgb_fg.png", hook_play_board = "hook_play_board.png", hook_pole = "hook_pole.png", hook_pole_2 = "hook_pole_2.png", hook_power_bg = "hook_power_bg.png", hook_stage_board = "hook_stage_board.png", hook_title_split = "hook_title_split.png", hook_rate_bg = "hook_rate_bg.png", hook_stage_lbl_bg = "hook_stage_lbl_bg.png", hook_bar_bg = "hook_bar_bg.png", hookmap_bg_b = "hookmap_bg_b.png", hookmap_bg1 = "hookmap_bg1.png", hookmap_bg2 = "hookmap_bg2.png", hookmap_bg_e = "hookmap_bg_e.png", hook_dmap_b = "hook_dmap_b.png", hook_dmap_1 = "hook_dmap_1.png", hook_dmap_2 = "hook_dmap_2.png", hook_dmap_3 = "hook_dmap_3.png", hook_dmap_e = "hook_dmap_e.png", hook_drmap_b = "hook_drmap_b.png", hook_drmap_1 = "hook_drmap_1.png", hook_drmap_2 = "hook_drmap_2.png", hook_drmap_3 = "hook_drmap_3.png", hook_drmap_e = "hook_drmap_e.png", hook_hmap_b = "hook_hmap_b.png", hook_hmap_1 = "hook_hmap_1.png", hook_hmap_2 = "hook_hmap_2.png", hook_hmap_3 = "hook_hmap_3.png", hook_hmap_e = "hook_hmap_e.png", hook_stage_focus = "hook_stage_focus.png", hook_model_0 = "hook_model_0.png", hook_model_1 = "hook_model_1.png", hook_hell_0 = "hook_hell_0.png", hook_hell_1 = "hook_hell_1.png", hook_diffic_0 = "hook_diffic_0.png", hook_diffic_1 = "hook_diffic_1.png", hook_normol_0 = "hook_normol_0.png", hook_normol_1 = "hook_normol_1.png", hook_nmare_0 = "hook_nmare_0.png", hook_nmare_1 = "hook_nmare_1.png", hook_dream_0 = "hook_dream_0.png", hook_dream_1 = "hook_dream_1.png", hook_map_titlebg = "hook_map_titlebg.png", casino_bg = "casino_bg.png", highcasino_bg = "highcasino_bg.png", casino_10draw = "casino_10draw.png", casino_1draw = "casino_1draw.png", casino_base = "casino_base.png", casino_chip = "casino_chip.png", casino_circle1 = "casino_circle1.png", casino_circle2 = "casino_circle2.png", casino_pointer = "casino_pointer.png", casino_ring = "casino_ring.png", casino_limit = "casino_limit.png", casino_coin = "casino_coin.png", casino_gem_bg = "casino_gem_bg.png", casino_reward_bg = "casino_reward_bg.png", casino_reward_top = "casino_reward_top.png", casino_shop_bottom = "casino_shop_bottom.png", casino_shop_frame = "casino_shop_frame.png", casino_shop_btn = "casino_shop_btn.png", casino_shop_mm = "casino_shop_mm.png", casino_shop_lcoin = "casino_shop_lcoin.png", casino_shop_limit = "casino_shop_limit.png", casino_shop_top = "casino_shop_top.png", casino_btn_shop = "casino_btn_shop.png", casino_btn_log = "casino_btn_log.png", casino_advanced = "casino_advanced.png", casino_common = "casino_common.png", smith_bg = "smith_bg.png", smith_bottom = "smith_bottom.png", smith_forge_board = "smith_forge_board.png", smith_resourse_trough = "smith_resourse_trough.png", smith_shackle = "smith_shackle.png", smith_roof = "smith_roof.png", smith_armour0 = "smith_armour0.png", smith_armour1 = "smith_armour1.png", smith_jewelry0 = "smith_jewelry0.png", smith_jewelry1 = "smith_jewelry1.png", smith_shoe0 = "smith_shoe0.png", smith_shoe1 = "smith_shoe1.png", smith_weapon0 = "smith_weapon0.png", smith_weapon1 = "smith_weapon1.png", smith_drop_bg = "smith_drop_bg.png", setting_aud_off = "setting_aud_off.png", setting_aud_on = "setting_aud_on.png", setting_help_content_bg = "setting_help_content_bg.png", setting_icon_fb = "setting_icon_fb.png", setting_icon_new = "setting_icon_new.png", setting_icon_arrow = "setting_icon_arrow.png", setting_icon_fix_bar = "setting_icon_fix_bar.png", setting_lgg_world = "setting_lgg_world.png", setting_lgg_de = "setting_lgg_de.png", setting_lgg_en = "setting_lgg_en.png", setting_lgg_es = "setting_lgg_es.png", setting_lgg_fr = "setting_lgg_fr.png", setting_lgg_hk = "setting_lgg_hk.png", setting_lgg_jp = "setting_lgg_jp.png", setting_lgg_kr = "setting_lgg_kr.png", setting_lgg_mask = "setting_lgg_mask.png", setting_lgg_pt = "setting_lgg_pt.png", setting_lgg_ru = "setting_lgg_ru.png", setting_lgg_tr = "setting_lgg_tr.png", setting_lgg_cn = "setting_lgg_cn.png", setting_lgg_it = "setting_lgg_it.png", setting_lgg_th = "setting_lgg_th.png", setting_lgg_vi = "setting_lgg_vi.png", setting_lgg_ms = "setting_lgg_ms.png", setting_msc_off = "setting_msc_off.png", setting_msc_on = "setting_msc_on.png", setting_server_focus = "setting_server_focus.png", setting_server_sel = "setting_server_sel.png", setting_tab_help_norm = "setting_tab_help_norm.png", setting_tab_help_sel = "setting_tab_help_sel.png", setting_tab_opt_norm = "setting_tab_opt_norm.png", setting_tab_opt_sel = "setting_tab_opt_sel.png", setting_tab_svr_norm = "setting_tab_svr_norm.png", setting_tab_svr_sel = "setting_tab_svr_sel.png", setting_tab_pub_norm = "setting_tab_pub_norm.png", setting_tab_pub_sel = "setting_tab_pub_sel.png", setting_tab_feed_norm = "setting_tab_feed_norm.png", setting_tab_feed_sel = "setting_tab_feed_sel.png", setting_dark_bg = "setting_dark_bg.png", setting_fb_link = "setting_fb_link.png", setting_fb_link_cn = "setting_fb_link_cn.png", setting_btn_fb = "setting_btn_fb.png", setting_btn_tt = "setting_btn_tt.png", setting_btn_wx = "setting_btn_wx.png", setting_btn_weibo = "setting_btn_weibo.png", setting_email_link = "setting_email_link.png", ui_fix_bar_bg_1 = "ui_fix_bar_bg_1.png", ui_fix_bar_bg_2 = "ui_fix_bar_bg_2.png", ui_fix_bar_bottom = "ui_fix_bar_bottom.png", ui_fix_bar_center = "ui_fix_bar_center.png", ui_fix_bar_top = "ui_fix_bar_top.png", guild_flag = "guild_flag.png", guild_icon_admin = "guild_icon_admin.png", guild_icon_mail = "guild_icon_mail.png", guild_icon_mail2 = "guild_icon_mail2.png", guild_icon_edit = "guild_icon_edit.png", guild_icon_log = "guild_icon_log.png", guild_icon_mem = "guild_icon_mem.png", guild_icon_mem2 = "guild_icon_mem2.png", guild_icon_rank = "guild_icon_rank.png", guild_icon_sel = "guild_icon_sel.png", guild_icon_sign = "guild_icon_sign.png", guild_icon_quit = "guild_icon_quit.png", guild_info_bg = "guild_info_bg.png", guild_icon_gfight = "guild_icon_gfight.png", guild_mem_bg = "guild_mem_bg.png", guild_token_bg = "guild_token_bg.png", guild_split = "guild_split.png", guild_token_area = "guild_token_area.png", guild_topbar = "guild_topbar.png", guild_vtitle_bg = "guild_vtitle_bg.png", guild_exp_pgb_fg = "guild_exp_pgb_fg.png", gskill_arrow_h = "gskill_arrow_h.png", gskill_arrow_l = "gskill_arrow_l.png", gskill_bg = "gskill_bg.png", gskill_job_1 = "gskill_job_1.png", gskill_job_2 = "gskill_job_2.png", gskill_job_3 = "gskill_job_3.png", gskill_job_4 = "gskill_job_4.png", gskill_job_5 = "gskill_job_5.png", gskill_tabh1 = "gskill_tabh1.png", gskill_tabh2 = "gskill_tabh2.png", gskill_tabh3 = "gskill_tabh3.png", gskill_tabh4 = "gskill_tabh4.png", gskill_tabh5 = "gskill_tabh5.png", gskill_tabl1 = "gskill_tabl1.png", gskill_tabl2 = "gskill_tabl2.png", gskill_tabl3 = "gskill_tabl3.png", gskill_tabl4 = "gskill_tabl4.png", gskill_tabl5 = "gskill_tabl5.png", guild_shop_light = "guild_shop_light.png", guild_shop_sell = "guild_shop_sell.png", guild_shop_top = "guild_shop_top.png", guild_shop_tower = "guild_shop_tower.png", activity_bar = "activity_bar.png", activity_bar_icon = "activity_bar_icon.png", activity_board = "activity_board.png", activity_item_bg = "activity_item_bg.png", activity_item_bg_sel = "activity_item_bg_sel.png", activity_icon_mcard = "activity_icon_mcard.png", activity_icon_monthly_gift = "activity_icon_monthly_gift.png", activity_icon_weekly_gift = "activity_icon_weekly_gift.png", activity_icon_spesummon = "activity_icon_spesummon.png", activity_icon_summon = "activity_icon_summon.png", activity_icon_summon_score = "activity_icon_summon_score.png", activity_icon_casino = "activity_icon_casino.png", activity_icon_vp = "activity_icon_vp.png", activity_icon_hw = "activity_icon_hw.png", activity_icon_tg = "activity_icon_tg.png", activity_icon_fight = "activity_icon_fight.png", activity_icon_mini = "activity_icon_mini.png", activity_icon_forge = "activity_icon_forge.png", activity_icon_exchange = "activity_icon_exchange.png", activity_icon_tarven = "activity_icon_tarven.png", activity_icon_winter = "activity_icon_winter.png", activity_icon_spring = "activity_icon_spring.png", activity_icon_cdkey = "activity_icon_cdkey.png", activity_icon_blackbox = "activity_icon_blackbox.png", activity_icon_newyearcard = "activity_icon_newyearcard.png", acticity_icon_anniversary = "acticity_icon_anniversary.png", acticity_icon_anniversarycard = "acticity_icon_anniversarycard.png", acticity_icon_summonmimu = "acticity_icon_summonmimu.png", activity_icon_element = "activity_icon_element.png", activity_monthly_gift = "activity_monthly_gift.png", activity_weekly_gift = "activity_weekly_gift.png", activity_summon_board = "activity_summon_board.png", activity_spesummon_board = "activity_spesummon_board.png", activity_summon_score_board = "activity_summon_score_board.png", activity_wishing_board = "activity_wishing_board.png", activity_forge_board = "activity_forge_board.png", activity_forge_head_icon1 = "activity_forge_head_icon1.png", activity_forge_head_icon2 = "activity_forge_head_icon2.png", activity_vp_board = "activity_vp_board.png", activity_hw_board = "activity_hw_board.png", activity_tg_board = "activity_tg_board.png", activity_winter_board = "activity_winter_board.png", activity_spring_board = "activity_spring_board.png", activity_fight_board = "activity_fight_board.png", activity_exchange_board = "activity_exchange_board.png", activity_tarven_board = "activity_tarven_board.png", activity_cdkey_board = "activity_cdkey_board.png", activity_pgb_casino = "activity_pgb_casino.png", activity_icon_crush1 = "activity_icon_crush1.png", activity_icon_crush2 = "activity_icon_crush2.png", activity_icon_crush3 = "activity_icon_crush3.png", activity_crush_board1 = "activity_crush_board1.png", activity_crush_board2 = "activity_crush_board2.png", activity_crush_board3 = "activity_crush_board3.png", activity_fish_board = "activity_fish_board.png", activity_pumpkin_board = "activity_pumpkin_board.png", activity_bell_board = "activity_bell_board.png", activity_newyear_board = "activity_newyear_board.png", activity_home_board = "activity_home_board.png", activity_icon_fish = "activity_icon_fish.png", activity_follow = "activity_follow.png", activity_icon_fb = "activity_icon_fb.png", activity_icon_weibo = "activity_icon_weibo.png", activity_icon_pumpkin = "activity_icon_pumpkin.png", activity_icon_bell = "activity_icon_bell.png", activity_icon_christmas = "activity_icon_christmas.png", activity_fb_ic = "activity_fb_ic.png", activity_weibo_ic = "activity_weibo_ic.png", activity_awaking_glory = "activity_awaking_glory.png", activity_hero_summon = "activity_hero_summon.png", activity_icon_awaking_glory = "activity_icon_awaking_glory.png", activity_icon_hero_summon = "activity_icon_hero_summon.png", activity_icon_change = "activity_icon_change.png", activity_change = "activity_change.png", activity_ten_change = "activity_ten_change.png", activity_ten_plus = "activity_ten_plus.png", activity_icon_blackcard = "activity_icon_blackcard.png", activity_blackcard = "activity_blackcard.png", activity_icon_asylum = "activity_icon_asylum.png", activity_asylum_a = "activity_asylum_a.png", activity_asylum_title = "activity_asylum_title.png", activity_asylum_tick = "activity_asylum_tick.png", activity_asylum_bottom = "activity_asylum_bottom.png", activity_newyear_titlebg = "activity_newyear_titlebg.png", activity_newyear_bar = "activity_newyear_bar.png", activity_newyear_bg = "activity_newyear_bg.png", activity_icon_newyear = "activity_icon_newyear.png", activity_icon_newyear2 = "activity_icon_newyear2.png", activity_newyear_barbg = "activity_newyear_barbg.png", activity_icon_tinyhome = "activity_icon_tinyhome.png", activity_icon_holylight = "activity_icon_holylight.png", activity_icon_stonefigure = "activity_icon_stonefigure.png", activity_icon_stonetablet = "activity_icon_stonetablet.png", activity_icon_darkremains = "activity_icon_darkremains.png", activity_icon_summer = "activity_icon_summer.png", activity_icon_tree = "activity_icon_tree.png", activity_icon_sea = "activity_icon_sea.png", acticity_icon_hallowmas_party = "acticity_icon_hallowmas_party.png", acticity_icon_weekbox = "acticity_icon_weekbox.png", activity_dwarf_raw = "activity_dwarf_raw.png", acticity_icon_dwarf = "acticity_icon_dwarf.png", activity_monthlybar_part1 = "activity_monthlybar_part1.png", activity_monthlybar_part2 = "activity_monthlybar_part2.png", activity_monthlybar_part3 = "activity_monthlybar_part3.png", activity_lightshop = "activity_lightshop.png", activity_lightshop_artifact0 = "activity_lightshop_artifact0.png", activity_lightshop_artifact1 = "activity_lightshop_artifact1.png", activity_lightshop_piece0 = "activity_lightshop_piece0.png", activity_lightshop_piece1 = "activity_lightshop_piece1.png", activity_lightshop_skin0 = "activity_lightshop_skin0.png", activity_lightshop_skin1 = "activity_lightshop_skin1.png", acticity_icon_treasure = "acticity_icon_treasure.png", activity_icon_dinner = "activity_icon_dinner.png", activity_icon_thansgiving = "activity_icon_thansgiving.png", activity_icon_friday_vip = "activity_icon_friday_vip.png", acticity_icon_christmas_dressup = "acticity_icon_christmas_dressup.png", activity_mid_autumn_board = "activity_mid_autumn_board.png", activity_mid_autumn_icon = "activity_mid_autumn_icon.png", activity_icon_friday_card = "activity_icon_friday_card.png", activity_icon_friday_happy = "activity_icon_friday_happy.png", activity_mid_autumn_price_bg = "activity_mid_autumn_price_bg.png", activity_mid_autumn_gift_icon = "activity_mid_autumn_gift_icon.png", activity_mid_autumn_gift_board = "activity_mid_autumn_gift_board.png", activity_mid_autumn_gift_flag = "activity_mid_autumn_gift_flag.png", activity_mid_autumn_gift_sel = "activity_mid_autumn_gift_sel.png", activity_mid_autumn_login_icon = "activity_mid_autumn_login_icon.png", activity_mid_autumn_login_board = "activity_mid_autumn_login_board.png", activity_mid_autumn_login_sel = "activity_mid_autumn_login_sel.png", activity_national_day_login_icon = "activity_national_day_login_icon.png", activity_national_day_login_top = "activity_national_day_login_top.png", activity_national_day_login_sel = "activity_national_day_login_sel.png", activity_national_day_login_bg = "activity_national_day_login_bg.png", activity_dinner_background = "activity_dinner_background.png", activity_dinner_roundback = "activity_dinner_roundback.png", activity_dinner_schedule1 = "activity_dinner_schedule1.png", activity_dinner_schedule2 = "activity_dinner_schedule2.png", activity_dinner_topback = "activity_dinner_topback.png", activity_dinner_level_circle = "activity_dinner_level_circle.png", activity_dinner_black = "activity_dinner_black.png", activity_friday_card_bg = "activity_friday_card_bg.png", activity_friday_card_lv = "activity_friday_card_lv.png", activity_friday_vip_banner = "activity_friday_vip_banner.png", activity_friday_happy_banner = "activity_friday_happy_banner.png", activity_friday_happy_sel = "activity_friday_happy_sel.png", activity_icon_christmas_card = "activity_icon_christmas_card.png", activity_christmas_card_bg = "activity_christmas_card_bg.png", activity_christmas_card_btn = "activity_christmas_card_btn.png", activity_christmas_card_round = "activity_christmas_card_round.png", activity_christmas_card_youxiang = "activity_christmas_card_youxiang.png", activity_christmas_card_level = "activity_christmas_card_level.png", limit_0 = "limit_0.png", limit_1 = "limit_1.png", limit_2 = "limit_2.png", limit_3 = "limit_3.png", limit_4 = "limit_4.png", limit_5 = "limit_5.png", limit_6 = "limit_6.png", limit_7 = "limit_7.png", limit_8 = "limit_8.png", limit_9 = "limit_9.png", limit_bottom = "limit_bottom.png", limit_first_icon = "limit_first_icon.png", limit_grade_icon = "limit_grade_icon.png", limit_level_icon = "limit_level_icon.png", limit_summon_icon = "limit_summon_icon.png", limit_select = "limit_select.png", limit_unselect = "limit_unselect.png", limit_top = "limit_top.png", limit_grade_gift = "limit_grade_gift.png", limit_level_gift = "limit_level_gift.png", limit_summon_gift = "limit_summon_gift.png", login_month_strengthen = "login_month_strengthen.png", login_month_tag = "login_month_tag.png", login_month_icon = "login_month_icon.png", login_month_black = "login_month_black.png", login_month_finish = "login_month_finish.png", login_month_line = "login_month_line.png", login_month_border = "login_month_border.png", mcard_board = "mcard_board.png", minicard_board = "minicard_board.png", firstpay_board = "firstpay_board.png", task_all_bg = "task_all_bg.png", task_pgb_fg = "task_pgb_fg.png", task_top = "task_top.png", guildvice_card_bg = "guildvice_card_bg.png", guildvice_card_box = "guildvice_card_box.png", guildvice_card_lbl = "guildvice_card_lbl.png", guildvice_card_mask = "guildvice_card_mask.png", guildvice_card_unlock = "guildvice_card_unlock.png", guildvice_dps_fg = "guildvice_dps_fg.png", guildvice_hp_bg = "guildvice_hp_bg.png", guildvice_hp_fg = "guildvice_hp_fg.png", guildvice_icon_drop = "guildvice_icon_drop.png", guildvice_bg = "guildvice_bg.png", guildvice_icon_dead = "guildvice_icon_dead.png", guildvice_icon_fight = "guildvice_icon_fight.png", guildvice_btn_fight = "guildvice_btn_fight.png", guildvice_scene_mask = "guildvice_scene_mask.png", guildvice_skill_sel = "guildvice_skill_sel.png", guildvice_sl_bg = "guildvice_sl_bg.png", guildvice_sl_light = "guildvice_sl_light.png", guildvice_skill_mask = "guildvice_skill_mask.png", guildvice_firebar = "guildvice_firebar.png", guildvice_hpbar = "guildvice_hpbar.png", guildvice_hpbarbg = "guildvice_hpbarbg.png", guild_mill_order_0 = "guild_mill_order_0.png", guild_mill_order_1 = "guild_mill_order_1.png", guild_mill_drank_0 = "guild_mill_drank_0.png", guild_mill_drank_1 = "guild_mill_drank_1.png", guild_mill_upgrade_0 = "guild_mill_upgrade_0.png", guild_mill_upgrade_1 = "guild_mill_upgrade_1.png", guild_mill_1 = "guild_mill_1.png", guild_mill_2 = "guild_mill_2.png", guild_mill_3 = "guild_mill_3.png", guild_mill_4 = "guild_mill_4.png", guild_mill_5 = "guild_mill_5.png", guild_mill_6 = "guild_mill_6.png", guild_mill_7 = "guild_mill_7.png", guild_mill_8 = "guild_mill_8.png", guild_mill_9 = "guild_mill_9.png", guild_mill_10 = "guild_mill_10.png", guild_mill_bottom_star = "guild_mill_bottom_star.png", guild_mill_coinbg = "guild_mill_coinbg.png", guild_mill_coinpro = "guild_mill_coinpro.png", guild_mill_coinprobg = "guild_mill_coinprobg.png", guild_mill_order1 = "guild_mill_order1.png", guild_mill_order2 = "guild_mill_order2.png", guild_mill_order3 = "guild_mill_order3.png", guild_mill_order4 = "guild_mill_order4.png", guild_mill_order5 = "guild_mill_order5.png", guild_mill_order6 = "guild_mill_order6.png", guild_mill_btn_record = "guild_mill_btn_record.png", guild_mill_win = "guild_mill_win.png", guild_mill_lose = "guild_mill_lose.png", guild_mill_timebg = "guild_mill_timebg.png", guild_mill_branch = "guild_mill_branch.png", guild_mill_star_s = "guild_mill_star_s.png", guild_mill_orderup = "guild_mill_orderup.png", guild_mill_ordertips = "guild_mill_ordertips.png", dare_entry_coin = "dare_entry_coin.png", dare_entry_exp = "dare_entry_exp.png", dare_entry_soul = "dare_entry_soul.png", dare_icon_stage1 = "dare_icon_stage1.png", dare_icon_stage2 = "dare_icon_stage2.png", dare_icon_stage3 = "dare_icon_stage3.png", dare_icon_stage4 = "dare_icon_stage4.png", dare_icon_stage5 = "dare_icon_stage5.png", dare_icon_stage6 = "dare_icon_stage6.png", dare_icon_stage7 = "dare_icon_stage7.png", dare_icon_stage8 = "dare_icon_stage8.png", summontree_replace_bg = "summontree_replace_bg.png", summontree_summon_bg = "summontree_summon_bg.png", summontree_hshadow = "summontree_hshadow.png", summontree_icon1 = "summontree_icon1.png", summontree_icon2 = "summontree_icon2.png", summontree_lef_bottom = "summontree_lef_bottom.png", summontree_rig_bottom = "summontree_rig_bottom.png", summontree_line = "summontree_line.png", summontree_raw = "summontree_raw.png", summontree_click = "summontree_click.png", tutorial_arrow = "tutorial_arrow.png", tutorial_bubble = "tutorial_bubble.png", tutorial_bubble_arrow = "tutorial_bubble_arrow.png", tutorial_text_bg = "tutorial_text_bg.png", tutorial_icon_add = "tutorial_icon_add.png", tutorial_icon_atk = "tutorial_icon_atk.png", tutorial_icon_def = "tutorial_icon_def.png", tutorial_stand_info_bg = "tutorial_stand_info_bg.png", treasure_bar_0 = "treasure_bar_0.png", treasure_bar_1 = "treasure_bar_1.png", treasure_up = "treasure_up.png", treasure_eq_bg = "treasure_eq_bg.png", airisland_bg = "airisland_bg.png", airisland_lvbg = "airisland_lvbg.png", airisland_stockbar = "airisland_stockbar.png", airisland_bumper_1 = "airisland_bumper_1.png", airisland_bumper_2 = "airisland_bumper_2.png", airisland_bumper_3 = "airisland_bumper_3.png", airisland_diamond_1 = "airisland_diamond_1.png", airisland_diamond_2 = "airisland_diamond_2.png", airisland_diamond_3 = "airisland_diamond_3.png", airisland_energy_1 = "airisland_energy_1.png", airisland_energy_2 = "airisland_energy_2.png", airisland_energy_3 = "airisland_energy_3.png", airisland_gale_1 = "airisland_gale_1.png", airisland_gale_2 = "airisland_gale_2.png", airisland_gale_3 = "airisland_gale_3.png", airisland_gold_1 = "airisland_gold_1.png", airisland_gold_2 = "airisland_gold_2.png", airisland_gold_3 = "airisland_gold_3.png", airisland_magic_1 = "airisland_magic_1.png", airisland_magic_2 = "airisland_magic_2.png", airisland_magic_3 = "airisland_magic_3.png", airisland_maintower_1 = "airisland_maintower_1.png", airisland_maintower_2 = "airisland_maintower_2.png", airisland_maintower_3 = "airisland_maintower_3.png", airisland_moon_1 = "airisland_moon_1.png", airisland_moon_2 = "airisland_moon_2.png", airisland_moon_3 = "airisland_moon_3.png", airisland_tyrant_1 = "airisland_tyrant_1.png", airisland_tyrant_2 = "airisland_tyrant_2.png", airisland_tyrant_3 = "airisland_tyrant_3.png", airisland_tip = "airisland_tip.png", airisland_sweep_bg = "airisland_sweep_bg.png", skin_book_select0 = "skin_book_select0.png", skin_book_select1 = "skin_book_select1.png", skin_piece_select0 = "skin_piece_select0.png", skin_piece_select1 = "skin_piece_select1.png", skin_select0 = "skin_select0.png", skin_select1 = "skin_select1.png", skin_frame = "skin_frame.png", skin_frame_sp = "skin_frame_sp.png", skin_piece = "skin_piece.png", skin_black = "skin_black.png", skin_circle = "skin_circle.png", skin_restskinbg = "skin_restskinbg.png", guildFight_icon_award = "guildFight_icon_award.png", guildFight_icon_ring = "guildFight_icon_ring.png", guildFight_icon_history = "guildFight_icon_history.png", guildFight_infoBg = "guildFight_infoBg.png", guildFight_bar_bg = "guildFight_bar_bg.png", guildFight_cut_line = "guildFight_cut_line.png", guildFight_icon_search = "guildFight_icon_search.png", guildFight_bar_2 = "guildFight_bar_2.png", guildFight_bar_16 = "guildFight_bar_16.png", guildFight_bar_4 = "guildFight_bar_4.png", guildFight_bar_8 = "guildFight_bar_8.png", guildFight_icon_final = "guildFight_icon_final.png", guildFight_anim_bg = "guildFight_anim_bg.png", guildFight_state_bg = "guildFight_state_bg.png", guildFight_fight_bg = "guildFight_fight_bg.png", guildFight_timer_bg = "guildFight_timer_bg.png", guildFight_vs_bg_1 = "guildFight_vs_bg_1.png", guildFight_vs_bg_2 = "guildFight_vs_bg_2.png", guildFight_line1 = "guildFight_line1.png", guildFight_line2 = "guildFight_line2.png", guildFight_champion_bg = "guildFight_champion_bg.png", guildFight_final_16_bg = "guildFight_final_16_bg.png", guildFight_eye_close = "guildFight_eye_close.png", guildFight_eye_open = "guildFight_eye_open.png", guildFight_tick_bg = "guildFight_tick_bg.png", guildFight_line168 = "guildFight_line168.png", guildFight_tl = "guildFight_tl.png", guildFight_branch = "guildFight_branch.png", guildFight_bar_battle = "guildFight_bar_battle.png", guildFight_battle_1 = "guildFight_battle_1.png", guildFight_battle_2 = "guildFight_battle_2.png", guildFight_battle_3 = "guildFight_battle_3.png", guildFight_find_1 = "guildFight_find_1.png", guildFight_find_2 = "guildFight_find_2.png", ui_private_service_left = "ui_private_service_left.png", ui_private_service_right = "ui_private_service_right.png", friend_pvp_biaotiban = "friend_pvp_biaotiban.png", friend_pvp_biaotidiban = "friend_pvp_biaotidiban.png", friend_pvp_captain = "friend_pvp_captain.png", friend_pvp_icon_putong = "friend_pvp_icon_putong.png", friend_pvp_icon_zudui = "friend_pvp_icon_zudui.png", friend_pvp_icon = "friend_pvp_icon.png", friend_pvp_left = "friend_pvp_left.png", friend_pvp_maoding = "friend_pvp_maoding.png", friend_pvp_pic = "friend_pvp_pic.png", friend_pvp_shiban = "friend_pvp_shiban.png", friend_pvp_shop = "friend_pvp_shop.png", friend_pvp_shopbg = "friend_pvp_shopbg.png", friend_pvp_teaminfo = "friend_pvp_teaminfo.png", friend_pvp_line = "friend_pvp_line.png", friend_pvp_blackpl = "friend_pvp_blackpl.png", friend_pvp_emptypos = "friend_pvp_emptypos.png", pet_bg = "pet_bg.png", pet_buff_sele = "pet_buff_sele.png", pet_buff_unsele = "pet_buff_unsele.png", pet_info_sele = "pet_info_sele.png", pet_info_unsele = "pet_info_unsele.png", pet_search = "pet_search.png", pet_card = "pet_card.png", pet_card2 = "pet_card2.png", pet_card3 = "pet_card3.png", pet_deer_1 = "pet_deer_1.png", pet_deer_2 = "pet_deer_2.png", pet_deer_3 = "pet_deer_3.png", pet_deer_4 = "pet_deer_4.png", pet_dragon_1 = "pet_dragon_1.png", pet_dragon_2 = "pet_dragon_2.png", pet_dragon_3 = "pet_dragon_3.png", pet_dragon_4 = "pet_dragon_4.png", pet_eagle_1 = "pet_eagle_1.png", pet_eagle_2 = "pet_eagle_2.png", pet_eagle_3 = "pet_eagle_3.png", pet_eagle_4 = "pet_eagle_4.png", pet_fox_1 = "pet_fox_1.png", pet_fox_2 = "pet_fox_2.png", pet_fox_3 = "pet_fox_3.png", pet_fox_4 = "pet_fox_4.png", pet_wolf_1 = "pet_wolf_1.png", pet_wolf_2 = "pet_wolf_2.png", pet_wolf_3 = "pet_wolf_3.png", pet_wolf_4 = "pet_wolf_4.png", pet_stone_1 = "pet_stone_1.png", pet_stone_2 = "pet_stone_2.png", pet_stone_3 = "pet_stone_3.png", pet_stone_4 = "pet_stone_4.png", pet_viper_1 = "pet_viper_1.png", pet_viper_2 = "pet_viper_2.png", pet_viper_3 = "pet_viper_3.png", pet_viper_4 = "pet_viper_4.png", pet_ice_1 = "pet_ice_1.png", pet_ice_2 = "pet_ice_2.png", pet_ice_3 = "pet_ice_3.png", pet_ice_4 = "pet_ice_4.png", pet_skill_sele = "pet_skill_sele.png", pet_btn = "pet_btn.png", pet_leg = "pet_leg.png", pet_101 = "pet_101.png", pet_201 = "pet_201.png", pet_301 = "pet_301.png", pet_401 = "pet_401.png", pet_501 = "pet_501.png", pet_601 = "pet_601.png", pet_701 = "pet_701.png", pet_801 = "pet_801.png", battlebuff_1 = "battlebuff_1.png", battlebuff_2 = "battlebuff_2.png", battlebuff_3 = "battlebuff_3.png", battlebuff_4 = "battlebuff_4.png", battlebuff_5 = "battlebuff_5.png", battlebuff_6 = "battlebuff_6.png", battlebuff_7 = "battlebuff_7.png", battlebuff_8 = "battlebuff_8.png", battlebuff_9 = "battlebuff_9.png", battlebuff_10 = "battlebuff_10.png", battlebuff_11 = "battlebuff_11.png", battlebuff_12 = "battlebuff_12.png", battlebuff_13 = "battlebuff_13.png", battlebuff_14 = "battlebuff_14.png", battlebuff_15 = "battlebuff_15.png", battlebuff_16 = "battlebuff_16.png", language_advance_cn = "language_advance_cn.png", language_advance_us = "language_advance_us.png", language_reward_cn = "language_reward_cn.png", language_reward_us = "language_reward_us.png", language_upgrade_cn = "language_upgrade_cn.png", language_upgrade_tw = "language_upgrade_tw.png", language_upgrade_us = "language_upgrade_us.png", language_upgrade_jp = "language_upgrade_jp.png", language_upgrade_kr = "language_upgrade_kr.png", language_upgrade_ru = "language_upgrade_ru.png", language_upgrade_tr = "language_upgrade_tr.png", language_defeat_cn = "language_defeat_cn.png", language_defeat_us = "language_defeat_us.png", language_defeat_jp = "language_defeat_jp.png", language_defeat_kr = "language_defeat_kr.png", language_defeat_ru = "language_defeat_ru.png", language_victory_cn = "language_victory_cn.png", language_victory_us = "language_victory_us.png", language_victory_jp = "language_victory_jp.png", language_victory_kr = "language_victory_kr.png", language_victory_ru = "language_victory_ru.png", language_victory_tr = "language_victory_tr.png", solo_auto_battle_change = "solo_auto_battle_change.png", solo_auto_battle_normal = "solo_auto_battle_normal.png", solo_battle_btn = "solo_battle_btn.png", solo_battle_btn_gray = "solo_battle_btn_gray.png", solo_sword_blue = "solo_sword_blue.png", solo_sword_red = "solo_sword_red.png", solo_chest = "solo_chest.png", solo_crit_bar = "solo_crit_bar.png", solo_power_bar = "solo_power_bar.png", solo_speed_bar = "solo_speed_bar.png", solo_crit_potion_small = "solo_crit_potion_small.png", solo_crit_potion = "solo_crit_potion.png", solo_power_potion_small = "solo_power_potion_small.png", solo_power_potion = "solo_power_potion.png", solo_speed_potion_small = "solo_speed_potion_small.png", solo_speed_potion = "solo_speed_potion.png", solo_angel_potion = "solo_angel_potion.png", solo_evil_potion = "solo_evil_potion.png", solo_milk = "solo_milk.png", solo_skip = "solo_skip.png", solo_hp_mask = "solo_hp_mask.png", solo_victory = "solo_victory.png", solo_trader_btn = "solo_trader_btn.png", solo_trader_1 = "solo_trader_1.png", solo_trader_2 = "solo_trader_2.png", solo_trader_3 = "solo_trader_3.png", seal_land_background = "seal_land_background.png", seal_land_board_level = "seal_land_board_level.png", seal_land_next = "seal_land_next.png", seal_land_sweep = "seal_land_sweep.png", seal_land_challenge = "seal_land_challenge.png", seal_land_lock = "seal_land_lock.png", seal_land_shop_icon = "seal_land_shop_icon.png", seal_land_shop_bg = "seal_land_shop_bg.png", seal_land_shadow = "seal_land_shadow.png", mmarket_bg = "mmarket_bg.png", mmarket_point = "mmarket_point.png", mmarket_shopback = "mmarket_shopback.png", treasure_bg = "treasure_bg.png", treasure_board1 = "treasure_board1.png", treasure_icon = "treasure_icon.png", activity_thanksgiving_board = "activity_thanksgiving_board.png", vip_subscribe_app = "vip_subscribe_app.png", vip_subscribe_bg = "vip_subscribe_bg.png", vip_subscribe_des = "vip_subscribe_des.png", vip_subscribe_restore = "vip_subscribe_restore.png", vip_subscribe_title = "vip_subscribe_title.png", vip_mcard_bg = "vip_mcard_bg.png", vip_minicard_bg = "vip_minicard_bg.png", activity_home_bg = "activity_home_bg.png", activity_home_board = "activity_home_board.png", activity_home_item_bg1 = "activity_home_item_bg1.png", activity_home_item_bg2 = "activity_home_item_bg2.png", activity_home_leaf_bg = "activity_home_leaf_bg.png", activity_home_leaf = "activity_home_leaf.png", activity_home_tab1 = "activity_home_tab1.png", activity_home_tab2 = "activity_home_tab2.png", activity_home_top = "activity_home_top.png", activity_home_tab3 = "activity_home_tab3.png", activity_home_cloud = "activity_home_cloud.png", activity_home_icon_bg = "activity_home_icon_bg.png", activity_home_item_bg3 = "activity_home_item_bg3.png", activity_home_flower = "activity_home_flower.png", login_reward_bg = "login_reward_bg.png", login_reward_recet = "login_reward_recet.png", login_reward_shadow = "login_reward_shadow.png", login_reward_shadow2 = "login_reward_shadow2.png", login_reward_y = "login_reward_y.png", transchage_bg = "transchage_bg.png", transchage_flower1 = "transchage_flower1.png", transchage_flower2 = "transchage_flower2.png", transchage_paper = "transchage_paper.png", transchage_wenhao = "transchage_wenhao.png", ui_christmas_dressup_bg = "ui_christmas_dressup_bg.png", ui_christmas_dressup_snowman_1 = "ui_christmas_dressup_snowman_1.png", ui_christmas_dressup_snowman_2 = "ui_christmas_dressup_snowman_2.png", ui_christmas_dressup_snowman_3 = "ui_christmas_dressup_snowman_3.png", ui_christmas_dressup_snowman_4 = "ui_christmas_dressup_snowman_4.png", ui_christmas_dressup_box = "ui_christmas_dressup_box.png", ui_christmas_dressup_ribbon = "ui_christmas_dressup_ribbon.png", ui_christmas_dressup_tree_1 = "ui_christmas_dressup_tree_1.png", ui_christmas_dressup_tree_2 = "ui_christmas_dressup_tree_2.png", ui_christmas_dressup_tree_3 = "ui_christmas_dressup_tree_3.png", ui_christmas_dressup_tree_4 = "ui_christmas_dressup_tree_4.png", ui_christmas_dressup_tree_5 = "ui_christmas_dressup_tree_5.png", ui_christmas_dressup_wreath_1 = "ui_christmas_dressup_wreath_1.png", ui_christmas_dressup_wreath_2 = "ui_christmas_dressup_wreath_2.png", ui_christmas_dressup_wreath_3 = "ui_christmas_dressup_wreath_3.png", socks_bg = "socks_bg.png", socks_biaoti = "socks_biaoti.png", socks_wazi_1 = "socks_wazi_1.png", socks_wazi_2 = "socks_wazi_2.png", socks_wazi_3 = "socks_wazi_3.png", socks_wazi_4 = "socks_wazi_4.png", socks_youxiang = "socks_youxiang.png"}
img.packedLogin = {logo = {"login_logo"}, common = {"spine_ui_common_1", "login_no_compress"}, home = {"login_home", "spine_ui_lag_loading", "spine_ui_gyro_1", "spine_ui_gyro_2"}}
img.getLoadingImgs = function()
  local imgs = {}
  for ii = 1, 1 do
    imgs[ii] = string.format("LOADING/Loading.%02d.png", ii)
  end
  return imgs
end

img.getFramesOfLoading = function(l_2_0)
  local frames = {}
  for ii = 1, #l_2_0 do
    local key = l_2_0[ii]
    local frame = spriteframeCache:spriteFrameByName(key)
    print("key=====:", key)
    if not frame then
      local tex = textureCache:addImage(key)
      local size = tex:getContentSize()
      local rect = CCRect(0, 0, size.width, size.height)
      frame = CCSpriteFrame:createWithTexture(tex, rect)
      frames[#frames + 1] = frame
      spriteframeCache:addSpriteFrame(frame, key)
    else
      frames[#frames + 1] = frame
    end
  end
  return frames
end

img.unloadFramesOfLoading = function(l_3_0)
  for ii = 1, #l_3_0 do
    local key = l_3_0[ii]
    local tex = textureCache:textureForKey(key)
    if tex then
      spriteframeCache:removeSpriteFramesFromTexture(tex)
      textureCache:removeTextureForKey(key)
    end
  end
end

img.packedUIFight = {ui_no_compress = "ui_no_compress", ui_common = "ui_common", ui_fight = "ui_fight", buff = "buff", item = "item", equip = "equip", skin = "skin", ui_hero = "ui_hero", ui_friend_pvp = "ui_friend_pvp", spine_ui_jjc_1 = "spine_ui_jjc_1", spine_ui_jjc_icon = "spine_ui_jjc_icon", spine_common = "spine_common", spine_ui_zhandou = "spine_ui_zhandou", spine_ui_common_1 = "spine_ui_common_1", ui_common = "ui_common", ui_bag = "ui_bag", ui_skin = "ui_skin", ui_herolist = "ui_herolist", head_1 = "head_1", head_no_compress = "head_no_compress", spine_fight_common_1 = "spine_fight_common_1", spine_ui_shengji = "spine_ui_shengji", ui_main = "ui_main", spine_ui_pvp_choujiang = "spine_ui_pvp_choujiang", spine_ui_3v3jiesuan = "spine_ui_3v3jiesuan", ui_language = "ui_language"}
img.packedUI = {buff = "buff", head_1 = "head_1", head_no_compress = "head_no_compress", equip = "equip", skin = "skin", item = "item", ui_common = "ui_common", ui_no_compress = "ui_no_compress", ui_main = "ui_main", ui_summon = "ui_summon", ui_summon_bg = "ui_summon_bg", ui_transchage = "ui_transchage", ui_transchage_bg = "ui_transchage_bg", ui_herolist = "ui_herolist", ui_select_hero = "ui_select_hero", ui_hero = "ui_hero", ui_devour = "ui_devour", ui_herotask = "ui_herotask", ui_fight = "ui_fight", ui_playerInfo = "ui_playerInfo", ui_bag = "ui_bag", ui_skin = "ui_skin", ui_bag_bg = "ui_bag_bg", ui_mail = "ui_mail", ui_midas = "ui_midas", ui_chat = "ui_chat", ui_player = "ui_player", spine_ui_zhuchangjing_winter_1 = "spine_ui_zhuchangjing_winter_1", spine_ui_zhuchangjing_winter_2 = "spine_ui_zhuchangjing_winter_2", spine_ui_seal_land = "spine_ui_main_shijianliefeng_summer", ui_blackmarket = "ui_blackmarket", ui_select_hero = "ui_select_hero", ui_friends = "ui_friends", ui_hook = "ui_hook", ui_casino = "ui_casino", ui_casino_reward_bg = "ui_casino_reward_bg", ui_casino_shop = "ui_casino_shop", ui_mmarket = "ui_mmarket", ui_achieve = "ui_achieve", ui_setting = "ui_setting", ui_fix_bar = "ui_fix_bar", ui_arena = "ui_arena", ui_guild = "ui_guild", ui_guild_shop = "ui_guild_shop", ui_guild_mill = "ui_guild_mill", ui_activity = "ui_activity", ui_limit = "ui_limit", ui_login_month = "ui_login_month", ui_task = "ui_task", ui_dare = "ui_dare", ui_tutorial = "ui_tutorial", ui_store = "ui_store", spine_common = "spine_common", spine_fight_common_1 = "spine_fight_common_1", spine_ui_common_1 = "spine_ui_common_1", spine_ui_heishi = "spine_ui_heishi", spine_ui_mailbox = "spine_ui_mailbox", spine_ui_hero_et = "spine_ui_hero_et", spine_ui_shengji = "spine_ui_shengji", spine_ui_devour_1 = "spine_ui_devour_1", spine_ui_devour_2 = "spine_ui_devour_2", spine_ui_heishishangren = "spine_ui_heishishangren", spine_ui_zhandou = "spine_ui_zhandou", spine_ui_3v3jiesuan = "spine_ui_3v3jiesuan", spine_ui_dianjin = "spine_ui_dianjin", spine_ui_dianjin2 = "spine_ui_dianjin2", spine_ui_jjc_1 = "spine_ui_jjc_1", spine_ui_daojishi = "spine_ui_daojishi", spine_ui_talk = "spine_ui_talk", spine_ui_lag_loading = "spine_ui_lag_loading", spine_ui_pvp_choujiang = "spine_ui_pvp_choujiang", spine_ui_yingxiong_hecheng_1 = "spine_ui_yingxiong_hecheng_1", spine_ui_yingxiong_hecheng_2 = "spine_ui_yingxiong_hecheng_2", spine_ui_main_summoning = "spine_ui_main_summoning", spine_ui_haoyouzhuzhan = "spine_ui_haoyouzhuzhan", spine_ui_zhanchong = "spine_ui_zhanchong", spine_ui_jjc_icon = "spine_ui_jjc_icon", spine_ui_huodong = "spine_ui_huodong", spine_ui_dantiaosai = "spine_ui_dantiaosai", spine_ui_1on1_1 = "spine_ui_1on1_1", spine_ui_sweep_ui = "spine_ui_sweep_ui", spine_ui_dts_shangren1 = "spine_ui_dts_shangren1", spine_ui_dts_shangren2 = "spine_ui_dts_shangren2", spine_ui_dts_shangren3 = "spine_ui_dts_shangren3", spine_ui_bianshen = "spine_ui_bianshen", spine_ui_lv10_framefx = "spine_ui_lv10_framefx", spine_ui_npc_order = "spine_ui_npc_order", spine_ui_double_icon = "spine_ui_double_icon", spine_ui_lv10plus_hero = "spine_ui_lv10plus_hero", spine_ui_cannon = "spine_ui_cannon", ui_treasure = "ui_treasure", ui_friend_pvp = "ui_friend_pvp", ui_pet_0 = "ui_pet_0", ui_pet_1 = "ui_pet_1", ui_pet_2 = "ui_pet_2", ui_pet_3 = "ui_pet_3", ui_pet_4 = "ui_pet_4", ui_pet_5 = "ui_pet_5", ui_pet_bg = "ui_pet_bg", ui_pet2 = "ui_pet2", ui_battlebuff = "ui_battlebuff", ui_language = "ui_language", ui_solo = "ui_solo"}
img.packedOthers = {fightLoading = {"ui_fight_load_1", "ui_fight_load_2"}, ui_firstpay = "ui_firstpay", ui_mcard = "ui_mcard", ui_minicard = "ui_minicard", ui_limit_grade = "ui_limit_grade", ui_limit_level = "ui_limit_level", ui_limit_summon = "ui_limit_summon", ui_activity_weekly_gift = "ui_activity_weekly_gift", ui_activity_blackcard = "ui_activity_blackcard", ui_activity_summon = "ui_activity_summon", ui_activity_spesummon = "ui_activity_spesummon", ui_activity_summon_score = "ui_activity_summon_score", ui_activity_casino = "ui_activity_casino", ui_activity_treasures = "ui_activity_treasures", ui_activity_thanksgiving = "ui_activity_thanksgiving", ui_activity_forge = "ui_activity_forge", ui_activity_vp = "ui_activity_vp", ui_activity_fight = "ui_activity_fight", ui_activity_exchange = "ui_activity_exchange", ui_activity_tarven = "ui_activity_tarven", ui_activity_christmas = "ui_activity_christmas", ui_activity_crushing_space1 = "ui_activity_crushing_space1", ui_activity_crushing_space2 = "ui_activity_crushing_space2", ui_activity_crushing_space3 = "ui_activity_crushing_space3", ui_activity_hero_summon = "ui_activity_hero_summon", ui_activity_cdkey = "ui_activity_cdkey", ui_activity_follow = "ui_activity_follow", ui_activity_change = "ui_activity_change", ui_activity_blackbox = "ui_activity_blackbox", ui_activity_hallowasparty = "ui_activity_hallowasparty", ui_activity_asylum = "ui_activity_asylum", ui_activity_element = "ui_activity_element", ui_activity_friday_vip = "ui_activity_friday_vip", ui_activity_friday_card = "ui_activity_friday_card", ui_activity_friday_happy = "ui_activity_friday_happy", ui_activity_socks = "ui_activity_socks", ui_activity_christmas_card = "ui_activity_christmas_card", ui_firstpay_cn = "ui_firstpay_cn", ui_mcard_cn = "ui_mcard_cn", ui_minicard_cn = "ui_minicard_cn", ui_limit_grade_cn = "ui_limit_grade_cn", ui_limit_level_cn = "ui_limit_level_cn", ui_limit_summon_cn = "ui_limit_summon_cn", ui_activity_spesummon_cn = "ui_activity_spesummon_cn", ui_activity_tarven_cn = "ui_activity_tarven_cn", ui_activity_christmas_cn = "ui_activity_christmas_cn", ui_activity_weekly_gift_cn = "ui_activity_weekly_gift_cn", ui_activity_hero_summon_cn = "ui_activity_hero_summon_cn", ui_activity_blackcard_cn = "ui_activity_blackcard_cn", ui_activity_dwarf = "ui_activity_dwarf", ui_activity_weekbox = "ui_activity_weekbox", ui_activity_mid_autumn = "ui_activity_mid_autumn", ui_activity_mid_autumn_gift = "ui_activity_mid_autumn_gift", ui_activity_mid_autumn_login = "ui_activity_mid_autumn_login", ui_activity_national_day_login = "ui_activity_national_day_login", ui_activity_dinner = "ui_activity_dinner", ui_activity_christmas_gift = "ui_activity_christmas_gift", ui_brave = "ui_brave", ui_brave_bg = "ui_brave_bg", spine_ui_yindao_girl = "spine_ui_yindao_girl", spine_ui_yindao_face = "spine_ui_yindao_face", spine_ui_baoshihecheng = "spine_ui_baoshihecheng", spine_ui_yingxiongmianban = "spine_ui_yingxiongmianban", spine_ui_yuanzheng_jiemian = "spine_ui_yuanzheng_jiemian", spine_ui_yuanzheng = "spine_ui_yuanzheng", spine_ui_shixingzhihuan = "spine_ui_shixingzhihuan", ui_guild_fight = "ui_guild_fight", ui_summontree = "ui_summontree", ui_summontree_bg = "ui_summontree_bg", spine_ui_shengmingzhishu = "spine_ui_shengmingzhishu", spine_ui_zhihuan = "spine_ui_zhihuan", ui_guildvice = "ui_guildvice", ui_guildvice_bg = "ui_guildvice_bg", spine_ui_mofang = "spine_ui_mofang", spine_ui_bt_changjing_1 = "spine_ui_bt_changjing_1", spine_ui_building_10 = "spine_ui_building_10", spine_ui_guildwar_ui = "spine_ui_guildwar_ui", spine_ui_yuanzheng_baoxiang = "spine_ui_yuanzheng_baoxiang", spine_ui_blacksmith_1 = "spine_ui_blacksmith_1", spine_ui_blacksmith_2 = "spine_ui_blacksmith_2", spine_ui_hanjingta_1 = "spine_ui_hanjingta_1", spine_ui_zhaohuan_1 = "spine_ui_zhaohuan_1", spine_ui_duchang_1 = "spine_ui_duchang_1", spine_ui_chongwu = "spine_ui_chongwu", spine_ui_tunvlang = "spine_ui_tunvlang", spine_ui_jiuguan_refresh = "spine_ui_jiuguan_refresh", spine_ui_chinesenewyear = "spine_ui_chinesenewyear", spine_ui_gonghui_qidao = "spine_ui_gonghui_qidao", spine_ui_gear_ui = "spine_ui_gear_ui", spine_ui_guoqing_qiandao = "spine_ui_guoqing_qiandao", spine_ui_fengshoubaozhang = "spine_ui_fengshoubaozhang", spine_ui_ganenwancan = "spine_ui_ganenwancan", spine_ui_kongzhan_1 = "spine_ui_kongzhan_1", spine_ui_guaji = "spine_ui_guaji", spine_ui_guild_1 = "spine_ui_guild_1", spine_fight_common_1 = "spine_fight_common_1", spine_ui_christmas_greetingcard = "spine_ui_christmas_greetingcard", spine_ui_christmas_greetingcard_boom = "spine_ui_christmas_greetingcard_boom", spine_ui_christmas_walk = "spine_ui_christmas_walk", spine_ui_christmas_card = "spine_ui_christmas_card", ui_hero_bg1 = "ui_hero_bg1", ui_hero_bg2 = "ui_hero_bg2", ui_hero_bg3 = "ui_hero_bg3", ui_hero_bg4 = "ui_hero_bg4", ui_hero_bg5 = "ui_hero_bg5", ui_hero_bg6 = "ui_hero_bg6", ui_casino_bg = "ui_casino_bg", ui_hero_forge_bg = "ui_hero_forge_bg", ui_smith_bg = "ui_smith_bg", ui_hookmap_bg1 = "ui_hookmap_bg1", ui_hookmap_bg2 = "ui_hookmap_bg2", ui_hook_dmap_1 = "ui_hook_dmap_1", ui_hook_dmap_2 = "ui_hook_dmap_2", ui_hook_dmap_3 = "ui_hook_dmap_3", ui_hook_hmap_1 = "ui_hook_hmap_1", ui_hook_hmap_2 = "ui_hook_hmap_2", ui_hook_hmap_3 = "ui_hook_hmap_3", ui_hook_drmap_1 = "ui_hook_drmap_1", ui_hook_drmap_2 = "ui_hook_drmap_2", ui_hook_drmap_3 = "ui_hook_drmap_3", ui_blackmarket_bg = "ui_blackmarket_bg", ui_devour_bg = "ui_devour_bg", ui_herotask_bg = "ui_herotask_bg", ui_airisland_bg = "ui_airisland_bg", ui_airisland = "ui_airisland", ui_smith = "ui_smith", ui_hero_forge = "ui_hero_forge", ui_dreamland = "ui_dreamland", ui_private_service = "ui_private_service", spine_ui_deer1 = "spine_ui_deer1", spine_ui_deer2 = "spine_ui_deer2", spine_ui_deer3 = "spine_ui_deer3", spine_ui_deer4 = "spine_ui_deer4", spine_ui_fox1 = "spine_ui_fox1", spine_ui_fox2 = "spine_ui_fox2", spine_ui_fox3 = "spine_ui_fox3", spine_ui_fox4 = "spine_ui_fox4", spine_ui_eagle1 = "spine_ui_griffin1", spine_ui_eagle2 = "spine_ui_griffin2", spine_ui_eagle3 = "spine_ui_griffin3", spine_ui_eagle4 = "spine_ui_griffin4", spine_ui_wolf1 = "spine_ui_wolf1", spine_ui_wolf2 = "spine_ui_wolf2", spine_ui_wolf3 = "spine_ui_wolf3", spine_ui_wolf4 = "spine_ui_wolf4", spine_ui_dragon1 = "spine_ui_dragon1", spine_ui_dragon2 = "spine_ui_dragon2", spine_ui_dragon3 = "spine_ui_dragon3", spine_ui_dragon4 = "spine_ui_dragon4", spine_ui_stone1 = "spine_ui_stone1", spine_ui_stone2 = "spine_ui_stone2", spine_ui_stone3 = "spine_ui_stone3", spine_ui_stone4 = "spine_ui_stone4", spine_ui_viper1 = "spine_ui_viper1", spine_ui_viper2 = "spine_ui_viper2", spine_ui_viper3 = "spine_ui_viper3", spine_ui_viper4 = "spine_ui_viper4", spine_ui_ice1 = "spine_ui_icesoul1", spine_ui_ice2 = "spine_ui_icesoul2", spine_ui_ice3 = "spine_ui_icesoul3", spine_ui_ice4 = "spine_ui_icesoul4", ui_vp_pop = "ui_vp_pop", ui_activity_home = "ui_activity_home", ui_vip_mcard = "ui_vip_mcard", ui_vip_minicard = "ui_vip_minicard", ui_vip_subscribe = "ui_vip_subscribe", ui_login_reward = "ui_login_reward", ui_transchage = "ui_transchage", ui_transchage_bg = "ui_transchage_bg", ui_christmas_dressup = "ui_christmas_dressup", spine_ui_Christmas = "spine_ui_Christmas"}
if APP_CHANNEL and APP_CHANNEL == "LT" then
  img.packedUI.ui_firstpay = "ui_firstpay_cn"
  img.packedUI.ui_mcard = "ui_mcard_cn"
  img.packedUI.ui_minicard = "ui_minicard_cn"
  img.packedOthers.ui_limit_grade = "ui_limit_grade_cn"
  img.packedOthers.ui_limit_level = "ui_limit_level_cn"
  img.packedOthers.ui_limit_summon = "ui_limit_summon_cn"
  img.packedOthers.ui_activity_spesummon = "ui_activity_spesummon_cn"
  img.packedOthers.ui_activity_weekly_gift = "ui_activity_weekly_gift_cn"
  img.packedOthers.ui_activity_blackcard = "ui_activity_blackcard_cn"
end
img.packedUnit = {}
img.initUnits = function()
  local ids = {}
  local i, j = 1, 1
  do
    local done = false
    repeat
      repeat
        repeat
          repeat
            if not done then
              repeat
                local id = i * 10 + j
                local idStr = string.format("%04d", id)
                local name = baseDir .. "spine_cha_" .. idStr .. ".plist"
                local path = CCFileUtils:sharedFileUtils():fullPathForFilename(name)
                if CCFileUtils:sharedFileUtils():isFileExist(path) then
                  img.packedUnit[id] = "spine_cha_" .. idStr
                  ids[#ids + 1] = {id = id, str = idStr}
                  j = j + 1
                else
                  j = j + 1
                  if j > 9 then
                    i = i + 1
                    j = 1
                until i > 250
                else
                  done = true
                  do return end
                end
              end
            else
              return ids
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

img.createLoginSprite = function(l_5_0)
  local fullname = loginDir .. l_5_0
  return CCSprite:createWithSpriteFrameName(fullname)
end

img.createLogin9Sprite = function(l_6_0)
  local fullname = loginDir .. l_6_0
  return CCScale9Sprite:createWithSpriteFrameName(fullname)
end

img.createUISprite = function(l_7_0)
  local fullname = uiDir .. l_7_0
  return CCSprite:createWithSpriteFrameName(fullname)
end

img.createUI9Sprite = function(l_8_0)
  local fullname = uiDir .. l_8_0
  return CCScale9Sprite:createWithSpriteFrameName(fullname)
end

img.createFxSequence = function(l_9_0)
  local cfgfx = require("config.fx")
  local cfg = cfgfx[l_9_0]
  local anim = CCAnimation:create()
  for i = 1, cfg.num do
    local name = baseDir .. "fx_sequence/" .. cfg.name .. i .. ".png"
    anim:addSpriteFrameWithFileName(name)
  end
  anim:setDelayPerUnit(cfg.duration / cfg.num)
  return anim
end

img.createPlayerHeadById = function(l_10_0)
  local cfghead = require("config.head")
  local headData = require("data.head")
  if l_10_0 <= #cfghead then
    local name = string.format("%s%04d.png", headDir, cfghead[l_10_0].iconId)
    return CCSprite:createWithSpriteFrameName(name)
  else
    return img.createHeroHeadIcon(l_10_0)
  end
end

img.createPlayerHead = function(l_11_0, l_11_1, l_11_2)
  local json = require("res.json")
  local cfghero = require("config.hero")
  local cfghead = require("config.head")
  local bg = img.createUISprite(img.ui.head_bg)
  local head = img.createPlayerHeadById(l_11_0)
  if cfghead[l_11_0] and cfghead[l_11_0].isShine then
    json.load(json.ui.touxiang)
    aniTouxiang = DHSkeletonAnimation:createWithKey(json.ui.touxiang)
    aniTouxiang:scheduleUpdateLua()
    aniTouxiang:playAnimation("animation", -1)
    aniTouxiang:setAnchorPoint(CCPoint(0.5, 0))
    aniTouxiang:setPosition(head:getContentSize().width / 2, head:getContentSize().height / 2)
    head:addChild(aniTouxiang)
  elseif not cfghead[l_11_0] and cfghero[l_11_0] and cfghero[l_11_0].maxStar == 10 then
    json.load(json.ui.touxiang)
    aniTouxiang = DHSkeletonAnimation:createWithKey(json.ui.touxiang)
    aniTouxiang:scheduleUpdateLua()
    aniTouxiang:playAnimation("animation", -1)
    aniTouxiang:setAnchorPoint(CCPoint(0.5, 0))
    aniTouxiang:setPosition(head:getContentSize().width / 2, head:getContentSize().height / 2)
    head:addChild(aniTouxiang)
  end
  if l_11_2 == true then
    head:setFlipX(true)
  end
  head:setScale(0.88)
  head:setPosition(bg:getContentSize().width / 2, bg:getContentSize().height / 2)
  bg:addChild(head)
  if l_11_1 then
    local showLvBg = img.createUI9Sprite(img.ui.main_lv_bg)
    if l_11_2 == true then
      showLvBg:setPosition(64, 14)
    else
      showLvBg:setPosition(20, 14)
    end
    bg:addChild(showLvBg, 1000)
    local lbl = require("res.lbl")
    local showLv = lbl.createFont2(14, l_11_1)
    showLv:setPosition(showLvBg:getContentSize().width / 2 - 1, showLvBg:getContentSize().height / 2)
    showLvBg:addChild(showLv)
  end
  return bg
end

img.createPlayerHeadForArena = function(l_12_0, l_12_1)
  local json = require("res.json")
  local cfghead = require("config.head")
  local bg = (img.createUISprite(img.ui.grid))
  local head = nil
  if cfghead[l_12_0] then
    head = img.createPlayerHeadById(l_12_0)
    if cfghead[l_12_0].isShine then
      json.load(json.ui.touxiang)
      aniTouxiang = DHSkeletonAnimation:createWithKey(json.ui.touxiang)
      aniTouxiang:scheduleUpdateLua()
      aniTouxiang:playAnimation("animation", -1)
      aniTouxiang:setAnchorPoint(CCPoint(0.5, 0))
      aniTouxiang:setPosition(head:getContentSize().width / 2, head:getContentSize().height / 2)
      head:addChild(aniTouxiang)
    else
      head = img.createHeroHeadIcon(l_12_0)
    end
  end
  head:setScale(0.95)
  head:setPosition(bg:getContentSize().width / 2, bg:getContentSize().height / 2)
  bg:addChild(head)
  if l_12_1 then
    local showLvBg = img.createUI9Sprite(img.ui.main_lv_bg)
    showLvBg:setPosition(20, 14)
    bg:addChild(showLvBg)
    local lbl = require("res.lbl")
    local showLv = lbl.createFont2(14, l_12_1)
    showLv:setPosition(showLvBg:getContentSize().width / 2 - 1, showLvBg:getContentSize().height / 2)
    showLvBg:addChild(showLv)
  end
  return bg
end

img.createGroupIcon = function(l_13_0)
  return img.createUISprite(img.ui.herolist_group_" .. l_13_)
end

img.createHeroHeadIcon = function(l_14_0)
  local info = getHeroDetailInfo(l_14_0)
  local name = string.format("%s%04d.png", headDir, info.icon)
  return CCSprite:createWithSpriteFrameName(name)
end

img.createHeroHeadByHid = function(l_15_0)
  local herosdata = require("data.heros")
  local h = herosdata.find(l_15_0)
  return img.createHeroHead(h.id, h.lv, true, true, h.wake, nil, nil, l_15_0)
end

img.createHeroHeadByParam = function(l_16_0)
  local json = require("res.json")
  local lbl = require("res.lbl")
  local cfgequip = require("config.equip")
  local id = l_16_0.id
  local lv = l_16_0.lv
  local showGroup = l_16_0.showGroup
  local showStar = l_16_0.showStar
  local wake = l_16_0.wake
  local orangeFx = orangeFx
  local petID = l_16_0.petID
  local hid = l_16_0.hid
  local skin = l_16_0.skin
  local info = (getHeroDetailInfo(id))
  local bg = nil
  if wake and wake >= 4 then
    bg = img.createUISprite(img.ui.hero_star_ten_bg)
  else
    bg = img.createUISprite(img.ui.herolist_head_bg)
  end
  bg:setCascadeOpacityEnabled(true)
  local bgSize = (bg:getContentSize())
  local icon = nil
  if hid then
    if getHeroSkin(hid) then
      icon = CCSprite:createWithSpriteFrameName(string.format("%s%04d.png", headDir, cfgequip[getHeroSkin(hid)].heroBody))
    else
      icon = CCSprite:createWithSpriteFrameName(string.format("%s%04d.png", headDir, info.icon))
    end
  elseif skin then
    icon = CCSprite:createWithSpriteFrameName(string.format("%s%04d.png", headDir, cfgequip[skin].heroBody))
  else
    icon = CCSprite:createWithSpriteFrameName(string.format("%s%04d.png", headDir, info.icon))
  end
  icon:setPosition(bgSize.width / 2, bgSize.height / 2)
  bg:addChild(icon)
  if petID ~= nil then
    local petSpr = img.createUISprite(img.ui.pet_" .. petI)
    petSpr:setPosition(CCPoint(petSpr:getContentSize().width / 2, petSpr:getContentSize().height / 2))
    bg:addChild(petSpr)
    local petJson = json.create(json.ui.petHint)
    petJson:playAnimation("animation", -1)
    petJson:setPosition(CCPoint(petSpr:getContentSize().width / 2, petSpr:getContentSize().height / 2))
    bg:addChild(petJson, 10)
  end
  if lv then
    local lvLabel = lbl.createFont2(18, lv)
    lvLabel:setPosition(74, 74)
    bg:addChild(lvLabel)
  end
  if showGroup and info.group and info.group ~= 9 then
    local groupBg = img.createUISprite(img.ui.herolist_group_bg)
    groupBg:setScale(0.45)
    groupBg:setPosition(18, 75)
    bg:addChild(groupBg)
    local groupIcon = img.createGroupIcon(info.group)
    groupIcon:setScale(0.45)
    groupIcon:setPosition(18, 77)
    bg:addChild(groupIcon)
  end
  if showStar then
    if info.qlt <= 5 then
      for i = info.qlt, 1, -1 do
        local star = img.createUISprite(img.ui.star_s)
        star:setPosition(bgSize.width / 2 + (i - (info.qlt + 1) / 2) * 12, 14)
        bg:addChild(star)
      end
    elseif info.qlt == 6 then
      local redstar = 1
      if wake and wake ~= 0 then
        redstar = wake + 1
      end
      if redstar >= 6 then
        json.load(json.ui.lv10plus_hero)
        local star = DHSkeletonAnimation:createWithKey(json.ui.lv10plus_hero)
        star:scheduleUpdateLua()
        star:playAnimation("animation", -1)
        star:setPosition(bgSize.width / 2, 14)
        bg:addChild(star, 100)
        local energizeStarLab = lbl.createFont2(26, redstar - 5)
        energizeStarLab:setPosition(star:getContentSize().width / 2, 0)
        star:addChild(energizeStarLab)
        star:setScale(0.53)
      elseif redstar >= 5 then
        local star = img.createUISprite(img.ui.hero_star_ten)
        star:setScale(0.96)
        star:setPosition(bgSize.width / 2, 14)
        bg:addChild(star)
      else
        for i = redstar, 1, -1 do
          local star = img.createUISprite(img.ui.hero_star_orange)
          star:setScale(0.75)
          star:setPosition(bgSize.width / 2 + (i - (redstar + 1) / 2) * 12, 14)
          bg:addChild(star)
        end
      end
    elseif info.qlt == 9 then
      local redstar = 4
      for i = redstar, 1, -1 do
        local star = img.createUISprite(img.ui.hero_star_orange)
        star:setScale(0.75)
        star:setPosition(bgSize.width / 2 + (i - (redstar + 1) / 2) * 12, 14)
        bg:addChild(star)
      end
    elseif info.qlt == 10 then
      local star = img.createUISprite(img.ui.hero_star_ten)
      star:setPosition(bgSize.width / 2, 14)
      bg:addChild(star)
    end
  end
end
return bg
end

img.createHeroHead = function(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4, l_17_5, l_17_6, l_17_7)
  local param = {id = l_17_0, lv = l_17_1, showGroup = l_17_2, showStar = l_17_3, wake = l_17_4, orangeFx = l_17_5, petID = l_17_6, hid = l_17_7}
  return img.createHeroHeadByParam(param)
end

img.createJobIcon = function(l_18_0)
  return img.createUISprite(img.ui.job_" .. l_18_)
end

img.createSkinIcon = function(l_19_0)
  local cfgequip = require("config.equip")
  return CCSprite:createWithSpriteFrameName(skinDir .. cfgequip[l_19_0].icon .. ".png")
end

img.createEquipIcon = function(l_20_0)
  local cfgequip = require("config.equip")
  return CCSprite:createWithSpriteFrameName(equipDir .. cfgequip[l_20_0].icon .. ".png")
end

img.createEquipQualityBg = function(l_21_0)
  local cfgequip = require("config.equip")
  return img.createUISprite(img.ui.equip_qlt_bg_" .. cfgequip[l_21_0].ql)
end

img.createSkinEquip = function(l_22_0)
  local cfgequip = require("config.equip")
  local w, h = 84, 84
  local bg = img.createUISprite(img.ui.herolist_head_bg)
  bg:setPosition(w / 2, h / 2)
  local bgSize = bg:getContentSize()
  local iconId = cfgequip[l_22_0].icon
  local icon = CCSprite:createWithSpriteFrameName(string.format("%s%04d.png", headDir, iconId))
  icon:setPosition(bgSize.width / 2, bgSize.height / 2)
  bg:addChild(icon)
  bg:setScale(0.89)
  return bg
end

img.createEquip = function(l_23_0, l_23_1)
  local lbl = require("res.lbl")
  local cfgequip = require("config.equip")
  local grid = img.createUISprite(img.ui.grid)
  local size = grid:getContentSize()
  grid:setCascadeOpacityEnabled(true)
  local quality = img.createEquipQualityBg(l_23_0)
  quality:setPosition(size.width / 2, size.height / 2)
  grid:addChild(quality)
  local icon = img.createEquipIcon(l_23_0)
  icon:setPosition(size.width / 2, size.height / 2)
  grid:addChild(icon)
  for i = 1, cfgequip[l_23_0].star do
    local star = img.createUISprite(img.ui.star_s_eq)
    star:setScale(0.9)
    star:setPosition(19, 7 + i * 10)
    grid:addChild(star)
  end
  if cfgequip[l_23_0].job then
    local job = img.createJobIcon(cfgequip[l_23_0].job[1])
    job:setPosition(size.width - 15, size.height - 15)
    grid:addChild(job)
  end
  if l_23_1 then
    local l = lbl.createFont2(14, convertItemNum(l_23_1))
    l:setAnchorPoint(ccp(1, 0))
    l:setPosition(70, 10)
    grid:addChild(l)
  end
  return grid
end

img.createHeroPieceIcon = function(l_24_0)
  local cfgitem = require("config.item")
  local w, h = 84, 84
  local container = CCSprite:create()
  container:setContentSize(CCSize(w, h))
  container:setCascadeOpacityEnabled(true)
  local icon = nil
  if l_24_0 == ITEM_ID_PIECE_Q3 then
    icon = img.createHeroHead(HERO_ID_ANY_Q3, nil, nil, true)
  elseif l_24_0 == ITEM_ID_PIECE_Q4 then
    icon = img.createHeroHead(HERO_ID_ANY_Q4, nil, nil, true)
  elseif l_24_0 == ITEM_ID_PIECE_Q5 then
    icon = img.createHeroHead(HERO_ID_ANY_Q5, nil, nil, true)
  elseif l_24_0 == ITEM_ID_PIECE_Q6 then
    icon = img.createHeroHead(HERO_ID_ANY_Q6, nil, nil, true)
  elseif l_24_0 == ITEM_ID_PIECE_SKIN then
    icon = img.createHeroHead(HERO_ID_SKIN, nil, nil, true)
  elseif l_24_0 == ITEM_ID_EXQ_Q5 then
    icon = img.createHeroHead(HERO_ID_EXQ_Q5, nil, nil, true)
  elseif l_24_0 == ITEM_ID_EXQ_LIGHT_Q5 then
    icon = img.createHeroHead(HERO_ID_EXQ_LIGHT_Q5, nil, true, true)
  elseif l_24_0 == ITEM_ID_EXQ_DARK_Q5 then
    icon = img.createHeroHead(HERO_ID_EXQ_DARK_Q5, nil, true, true)
  else
    if between(l_24_0 - ITEM_ID_PIECE_GROUP_Q3, 1, 9) then
      local group = l_24_0 - ITEM_ID_PIECE_GROUP_Q3
      icon = img.createHeroHead(HERO_ID_GROUP_Q3 + group * 100, nil, true, true)
    else
      if between(l_24_0 - ITEM_ID_PIECE_GROUP_Q4, 1, 9) then
        local group = l_24_0 - ITEM_ID_PIECE_GROUP_Q4
        icon = img.createHeroHead(HERO_ID_GROUP_Q4 + group * 100, nil, true, true)
      else
        if between(l_24_0 - ITEM_ID_PIECE_GROUP_Q5, 1, 9) then
          local group = l_24_0 - ITEM_ID_PIECE_GROUP_Q5
          icon = img.createHeroHead(HERO_ID_GROUP_Q5 + group * 100, nil, true, true)
        else
          icon = img.createHeroHead(cfgitem[l_24_0].heroCost.id, nil, true, true)
        end
      end
    end
  end
  icon:setScale(0.89)
  icon:setPosition(w / 2, h / 2)
  container:addChild(icon)
  return container
end

img.createSkinPieceIcon = function(l_25_0)
  local cfgitem = require("config.item")
  local cfgequip = require("config.equip")
  local w, h = 84, 84
  local container = CCSprite:create()
  container:setContentSize(CCSize(w, h))
  container:setCascadeOpacityEnabled(true)
  local bg = img.createUISprite(img.ui.herolist_head_bg)
  local bgSize = (bg:getContentSize())
  local iconId = nil
  if l_25_0 == ITEM_ID_PIECE_SKIN then
    iconId = HERO_ID_SKIN
  else
    iconId = cfgequip[cfgitem[l_25_0].equip.id].icon
  end
  local icon = CCSprite:createWithSpriteFrameName(string.format("%s%04d.png", headDir, iconId))
  icon:setPosition(bgSize.width / 2, bgSize.height / 2)
  bg:addChild(icon)
  bg:setScale(0.89)
  bg:setCascadeOpacityEnabled(true)
  bg:setPosition(w / 2, h / 2)
  container:addChild(bg)
  return container
end

img.createItemIcon = function(l_26_0)
  local cfgitem = require("config.item")
  return CCSprite:createWithSpriteFrameName(itemDir .. cfgitem[l_26_0].icon .. ".png")
end

img.createItemIcon2 = function(l_27_0)
  local cfgitem = require("config.item")
  return CCSprite:createWithSpriteFrameName(itemDir .. cfgitem[l_27_0].icon2 .. ".png")
end

img.createItemIconForId = function(l_28_0)
  return CCSprite:createWithSpriteFrameName(itemDir .. l_28_0 .. ".png")
end

img.createItem = function(l_29_0, l_29_1)
  local lbl = require("res.lbl")
  local cfghero = require("config.hero")
  local cfgitem = require("config.item")
  local cfgequip = (require("config.equip"))
  local bg, size = nil, nil
  if cfgitem[l_29_0].type == ITEM_KIND_HERO_PIECE then
    bg = img.createHeroPieceIcon(l_29_0)
    size = bg:getContentSize()
    local piece = img.createUISprite(img.ui.bag_piece)
    piece:setPosition(ccp(66, 65))
    bg:addChild(piece)
  else
    if cfgitem[l_29_0].type == ITEM_KIND_SKIN_PIECE then
      bg = img.createSkinPieceIcon(l_29_0)
      size = bg:getContentSize()
      if l_29_0 ~= ITEM_ID_PIECE_SKIN then
        local groupBg = img.createUISprite(img.ui.herolist_group_bg)
        groupBg:setScale(0.42)
        groupBg:setPosition(size.width / 2 - 25, size.height / 2 + 24)
        bg:addChild(groupBg)
        if cfgequip[cfgitem[l_29_0].equip.id].heroId[1] then
          local piecegroup = cfghero[cfgequip[cfgitem[l_29_0].equip.id].heroId[1]].group
          local groupIcon = img.createUISprite(img.ui.herolist_group_" .. piecegrou)
          groupIcon:setScale(0.42)
          groupIcon:setPosition(size.width / 2 - 25, size.height / 2 + 26)
          bg:addChild(groupIcon, 3)
        end
      end
      local quality = img.createUISprite(img.ui.skin_piece)
      quality:setPosition(size.width / 2 + 24, size.height / 2 + 24)
      bg:addChild(quality)
    else
      bg = img.createUISprite(img.ui.grid)
      size = bg:getContentSize()
      if cfgitem[l_29_0].type == item_kind_treasure_piece then
        local quality = img.createuisprite(img.ui.equip_qlt_bg_" .. cfgitem[l_29_0].ql)
        quality:setposition(size.width / 2, size.height / 2)
        bg:addchild(quality)
      end
      local icon = img.createItemIcon(l_29_0)
      icon:setPosition(size.width / 2, size.height / 2)
      bg:addChild(icon)
    end
  end
  bg:setCascadeOpacityEnabled(true)
  if l_29_1 then
    local l = lbl.createFont2(14, convertItemNum(l_29_1))
    l:setAnchorPoint(ccp(1, 0))
    l:setPosition(74, 6)
    bg:addChild(l)
    bg.lblNum = l
  end
  return bg
end

img.createSkill = function(l_30_0)
  local cfgskill = require("config.skill")
  return img.createSpriteUnpacked(baseDir .. skillDir .. cfgskill[l_30_0].iconId .. ".png")
end

img.unloadAllSkill = function()
  local cfgskill = require("config.skill")
  for _,cfg in ipairs(cfgskill) do
    if cfg.iconId then
      local fullname = baseDir .. skillDir .. cfg.iconId .. ".png"
      local tex = textureCache:textureForKey(fullname)
      if tex then
        spriteframeCache:removeSpriteFramesFromTexture(tex)
        textureCache:removeTextureForKey(fullname)
      end
    end
  end
end

img.createPetBuff = function(l_32_0)
  local cfgpetskill = require("config.petskill")
  return img.createSpriteUnpacked(baseDir .. skillDir .. cfgpetskill[l_32_0].icon .. ".png")
end

img.unloadAllPetBuff = function()
  local cfgskill = require("config.petskill")
  for _,cfg in ipairs(cfgskill) do
    if cfg.icon then
      local fullname = baseDir .. skillDir .. cfg.icon .. ".png"
      local tex = textureCache:textureForKey(fullname)
      if tex then
        spriteframeCache:removeSpriteFramesFromTexture(tex)
        textureCache:removeTextureForKey(fullname)
      end
    end
  end
end

img.createGSkill = function(l_34_0)
  local cfgguildskill = require("config.guildskill")
  return img.createSpriteUnpacked(baseDir .. gskillDir .. cfgguildskill[l_34_0].icon .. ".png")
end

img.unloadAllGSkill = function()
  local cfgskill = require("config.guildskill")
  for _,cfg in ipairs(cfgskill) do
    if cfg.icon then
      local fullname = baseDir .. gskillDir .. cfg.icon .. ".png"
      local tex = textureCache:textureForKey(fullname)
      if tex then
        spriteframeCache:removeSpriteFramesFromTexture(tex)
        textureCache:removeTextureForKey(fullname)
      end
    end
  end
end

img.createGTech = function(l_36_0)
  return img.createSpriteUnpacked(baseDir .. gtechDir .. cfgguildtech[l_36_0].icon .. ".png")
end

img.createGFlag = function(l_37_0)
  return img.createSpriteUnpacked(baseDir .. gflagDir .. l_37_0 .. ".png")
end

img.unloadAllGFlag = function()
  for ii = 1, 46 do
    local fullname = baseDir .. gflagDir .. ii .. ".png"
    local tex = textureCache:textureForKey(fullname)
    if tex then
      spriteframeCache:removeSpriteFramesFromTexture(tex)
      textureCache:removeTextureForKey(fullname)
    end
  end
end

img.unloadAllHeroBg = function()
  for ii = 1, 6 do
    img.unload("ui_hero_bg" .. ii)
  end
end

img.unloadForTown = function()
  img.unloadAllViceMap()
  img.unloadAllSkill()
  img.unloadAllPetBuff()
  img.unloadAllGSkill()
  img.unloadAllGFlag()
  img.unloadAllHeroBg()
end

img.createBuff = function(l_41_0)
  return CCSprite:createWithSpriteFrameName(buffDir .. l_41_0 .. ".png")
end

img.createBuffWithNum = function(l_42_0)
  local lbl = require("res.lbl")
  local icon = CCSprite:createWithSpriteFrameName(buffDir .. l_42_0 .. ".png")
  local lbl_num = lbl.createFont1(9, "", ccc3(255, 255, 255))
  lbl_num:setPosition(CCPoint(12, 4))
  icon:addChild(lbl_num, 100)
  icon.lbl = lbl_num
  return icon
end

img.createBatchNodeForUI = function(l_43_0)
  local frame = spriteframeCache:spriteFrameByName(uiDir .. l_43_0)
  return CCSpriteBatchNode:createWithTexture(frame:getTexture())
end

img.createHookMap = function(l_44_0)
  return img.createSpriteUnpacked(baseDir .. hookmapDir .. l_44_0 .. ".png")
end

img.unloadHookMap = function(l_45_0)
  if not l_45_0 then
    return 
  end
  local fullname = baseDir .. hookmapDir .. l_45_0 .. ".png"
  local tex = textureCache:textureForKey(fullname)
  if tex then
    spriteframeCache:removeSpriteFramesFromTexture(tex)
    textureCache:removeTextureForKey(fullname)
  end
end

img.createViceMap = function(l_46_0)
  return img.createSpriteUnpacked(baseDir .. vicemapDir .. l_46_0 .. ".png")
end

img.unloadAllViceMap = function()
  for ii = 1, 42 do
    local fullname = baseDir .. vicemapDir .. ii .. ".png"
    local tex = textureCache:textureForKey(fullname)
    if tex then
      spriteframeCache:removeSpriteFramesFromTexture(tex)
      textureCache:removeTextureForKey(fullname)
    end
  end
end

img.createLoading = function(l_48_0)
  return img.createSpriteUnpacked(baseDir .. loadingDir .. l_48_0 .. ".jpg")
end

img.createLoadingPng = function(l_49_0)
  return img.createSpriteUnpacked(baseDir .. loadingDir .. l_49_0 .. ".png")
end

img.unloadLoading = function(l_50_0)
  local fullname = baseDir .. loadingDir .. l_50_0
  local tex = textureCache:textureForKey(fullname .. ".jpg")
  if tex then
    textureCache:removeTextureForKey(fullname .. ".jpg")
  end
end

img.unloadLoadingPng = function(l_51_0)
  local fullname = baseDir .. loadingDir .. l_51_0
  local tex = textureCache:textureForKey(fullname .. ".png")
  if tex then
    textureCache:removeTextureForKey(fullname .. ".png")
  end
end

img.createFightMap = function(l_52_0)
  local name1 = string.format("%s%smap_%02d_a.png", baseDir, mapDir, l_52_0)
  local name2 = string.format("%s%smap_%02d_b.png", baseDir, mapDir, l_52_0)
  local bg = CCSprite:createWithSpriteFrameName(name1)
  local fg = CCSprite:createWithSpriteFrameName(name2)
  return bg, fg
end

local loadUnpacked = function(l_53_0, l_53_1)
  if spriteframeCache:spriteFrameByName(l_53_1) then
    return 
  end
  local tex = textureCache:addImage(l_53_0)
  local size = tex:getContentSize()
  local rect = CCRect(0, 0, size.width, size.height)
  local frame = CCSpriteFrame:createWithTexture(tex, rect)
  spriteframeCache:addSpriteFrame(frame, l_53_1)
end

img.createSpriteUnpacked = function(l_54_0)
  loadUnpacked(l_54_0, l_54_0)
  return CCSprite:createWithSpriteFrameName(l_54_0)
end

img.load = function(l_55_0)
  local fullname = baseDir .. l_55_0 .. ".plist"
  cclog("load %s", fullname)
  spriteframeCache:addSpriteFramesWithFile(fullname)
end

img.unload = function(l_56_0)
  local fullname = baseDir .. l_56_0
  local tex = textureCache:textureForKey(fullname .. ".png")
  if tex then
    spriteframeCache:removeSpriteFramesFromFile(fullname .. ".plist")
    textureCache:removeTextureForKey(fullname .. ".png")
  end
end

img.loadAll = function(l_57_0)
  for _,name in pairs(l_57_0) do
    img.load(name)
  end
end

img.unloadAll = function(l_58_0)
  for _,name in pairs(l_58_0) do
    img.unload(name)
  end
end

img.loadUnit = function(l_59_0)
  img.load(img.packedUnit[l_59_0])
end

img.unloadUnit = function(l_60_0)
  img.unload(img.packedUnit[l_60_0])
end

img.unloadAllUnits = function()
  for _,name in pairs(img.packedUnit) do
    img.unload(name)
  end
end

img.getLoadListForUI = function()
  local loadlist = {}
  local names = tablevalues(img.packedUI)
  for _,name in ipairs(names) do
    loadlist[#loadlist + 1] = {texture = baseDir .. name .. ".png", plist = baseDir .. name .. ".plist"}
  end
  return loadlist
end

img.getAllBuff = function()
  local cfgbuff = require("config.buff")
  local cfgfx = require("config.fx")
  local loadlist = {}
  local fxNames = {}
  for _,b in ipairs(cfgbuff) do
    if b.fx and cfgfx[b.fx] then
      fxNames[cfgfx[b.fx].name] = true
      if cfgfx[fx].resName then
        fxNames[cfgfx[b.fx].resName] = true
      end
    end
  end
  do
    local pngNames = tablecp(fxNames)
    for fxName,_ in pairs(fxNames) do
      if fxName:endwith("_start") then
        pngNames[fxName:sub(1, -7)] = true
        for fxName,_ in (for generator) do
        end
        if fxName:endwith("_loop") then
          pngNames[fxName:sub(1, -6)] = true
          for fxName,_ in (for generator) do
          end
          if fxName:endwith("_end") then
            pngNames[fxName:sub(1, -5)] = true
          end
        end
        pngNames.common = true
        for name,_ in pairs(pngNames) do
          local i = 1
          repeat
            repeat
              local texture = baseDir .. "spine_fight_" .. name .. "_" .. i .. ".png"
              local plist = baseDir .. "spine_fight_" .. name .. "_" .. i .. ".plist"
              local fullpath = CCFileUtils:sharedFileUtils():fullPathForFilename(texture)
              if CCFileUtils:sharedFileUtils():isFileExist(fullpath) then
                loadlist[#loadlist + 1] = {texture = texture, plist = plist}
                i = i + 1
                do return end
                for name,_ in (for generator) do
              else
                end
                return loadlist
              end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

img.getLoadListForFight = function(l_64_0, l_64_1, l_64_2)
  local cfghero = require("config.hero")
  local cfgskill = require("config.skill")
  local cfgfx = require("config.fx")
  local loadlist = {}
  if l_64_0 then
    for _,s in ipairs({"a", "b"}) do
      local name = string.format("%s%smap_%02d_%s.png", baseDir, mapDir, l_64_0, s)
      local path = CCFileUtils:sharedFileUtils():fullPathForFilename(name)
      if CCFileUtils:sharedFileUtils():isFileExist(path) then
        loadlist[#loadlist + 1] = {texture = name, frame = name}
      end
    end
  end
  for _,id in ipairs(l_64_1) do
    local unitResId = cfghero[id].heroBody
    loadlist[#loadlist + 1] = {texture = baseDir .. img.packedUnit[unitResId] .. ".png", plist = baseDir .. img.packedUnit[unitResId] .. ".plist"}
  end
  local fxNames = {}
  if not l_64_2 then
    for id,cfg in pairs(cfgfx) do
      local pre = string.sub(id, 1, 1)
      if pre == "2" or pre == "3" then
        fxNames[cfg.name] = true
      end
    end
  end
  local skArray = nil
  if l_64_2 then
    skArray = 
  else
    skArray = 
  end
  for _,id in {"atkId"}(l_64_1) do
    for _,s in ipairs(skArray) do
      local sk = cfghero[id][s]
      if sk then
        for _,f in ipairs({"fxSelf", "fxMain1", "fxMain2", "fxHurt1", "fxHurt2"}) do
          local fxes = cfgskill[sk][f]
          if fxes then
            for _,fx in ipairs(fxes) do
              fxNames[cfgfx[fx].name] = true
              if cfgfx[fx].resName then
                fxNames[cfgfx[fx].resName] = true
              end
            end
          end
        end
      end
    end
    if cfghero[id].disillusSkill then
      local cfgdisillusSkill = cfghero[id].disillusSkill
      for ii = 1, #cfgdisillusSkill do
        local cfgdisi = cfgdisillusSkill[ii].disi
        for jj = 1, #cfgdisi do
          local sk = cfgdisi[jj]
          local sks = {}
          sks[1] = sk
          if sk and cfgskill[sk] and cfgskill[sk].effect and cfgskill[sk].effect[1].type == "changeCombat" then
            sks[2] = cfgskill[sk].effect[1].num
          end
          for ii = 1, #sks do
            sk = sks[ii]
            if sk then
              for _,f in ipairs({"fxSelf", "fxMain1", "fxMain2", "fxHurt1", "fxHurt2"}) do
                local fxes = cfgskill[sk][f]
                if fxes then
                  for _,fx in ipairs(fxes) do
                    fxNames[cfgfx[fx].name] = true
                    if cfgfx[fx].resName then
                      fxNames[cfgfx[fx].resName] = true
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  do
    local pngNames = tablecp(fxNames)
    for fxName,_ in pairs(fxNames) do
      do
        if fxName:endwith("_start") then
          for fxName,_ in (for generator) do
          end
          if fxName:endwith("_loop") then
            for fxName,_ in (for generator) do
            end
        end
        if fxName:endwith("_end") then
          end
          for name,_ in pairs(pngNames) do
            local i = 1
            repeat
              repeat
                local texture = baseDir .. "spine_fight_" .. name .. "_" .. i .. ".png"
                local plist = baseDir .. "spine_fight_" .. name .. "_" .. i .. ".plist"
                local fullpath = CCFileUtils:sharedFileUtils():fullPathForFilename(texture)
                if CCFileUtils:sharedFileUtils():isFileExist(fullpath) then
                  loadlist[#loadlist + 1] = {texture = texture, plist = plist}
                  i = i + 1
                  do return end
                  for name,_ in (for generator) do
                else
                  end
                  return loadlist
                end
                 -- Warning: missing end command somewhere! Added here
              end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

img.getLoadListForFight2 = function(l_65_0, l_65_1, l_65_2)
  local cfghero = require("config.hero")
  local cfgskill = require("config.skill")
  local cfgfx = require("config.fx")
  local cfgequip = require("config.equip")
  local herosdata = require("data.heros")
  local loadlist = {}
  local fxNames = {}
  if l_65_0 then
    for _,s in ipairs({"a", "b"}) do
      local name = string.format("%s%smap_%02d_%s.png", baseDir, mapDir, l_65_0, s)
      local path = CCFileUtils:sharedFileUtils():fullPathForFilename(name)
      if CCFileUtils:sharedFileUtils():isFileExist(path) then
        loadlist[#loadlist + 1] = {texture = name, frame = name}
      end
    end
  end
  for _,hInfo in ipairs(l_65_1) do
    if hInfo.hid then
      local t_hero = herosdata.find(hInfo.hid)
      if t_hero then
        hInfo.id = t_hero.id
        if not hInfo.skin then
          hInfo.skin = getHeroSkin(hInfo.hid)
        end
      end
    end
    local unitResId = cfghero[hInfo.id].heroBody
    if hInfo.skin and cfgequip[hInfo.skin] then
      unitResId = cfgequip[hInfo.skin].heroBody
    end
    loadlist[#loadlist + 1] = {texture = baseDir .. img.packedUnit[unitResId] .. ".png", plist = baseDir .. img.packedUnit[unitResId] .. ".plist"}
    local skills = {}
    local skArray = nil
    if l_65_2 then
      skArray = {"atkId"}
    else
      skArray = {"atkId", "actSkillId", "pasSkill1Id", "pasSkill2Id", "pasSkill3Id"}
    end
    for _,s in ipairs(skArray) do
      if cfghero[hInfo.id][s] then
        skills[s] = cfghero[hInfo.id][s]
      end
    end
    if hInfo.wake and hInfo.wake > 0 and cfghero[hInfo.id].disillusSkill and cfghero[hInfo.id].disillusSkill[wake] then
      local _ss = cfghero[hInfo.id].disillusSkill[wake].disi
      skills.actSkillId = _ss[1]
      skills.pasSkill1Id = _ss[2]
      skills.pasSkill2Id = _ss[3]
      skills.pasSkill3Id = _ss[4]
    end
    for _,s in ipairs(skArray) do
      local sk = skills[s]
      if sk and cfgskill[sk] and cfgskill[sk].effect and cfgskill[sk].effect[1].type == "changeCombat" then
        skills.actId = cfgskill[sk].effect[1].num
      end
    end
    for _,s in ipairs(skArray) do
      if cfgskill[skills[s]] then
        for _,f in ipairs({"fxSelf", "fxMain1", "fxMain2", "fxHurt1", "fxHurt2"}) do
          local fxes = {}
          if cfgskill[skills[s]][f] then
            fxes = cfgskill[skills[s]][f]
          end
          if (hInfo.skin and cfgequip[hInfo.skin] and cfgequip[hInfo.skin][f]) or fxes then
            for _,fx in ipairs(fxes) do
              fxNames[cfgfx[fx].name] = true
              if cfgfx[fx].resName then
                fxNames[cfgfx[fx].resName] = true
              end
            end
          end
        end
      end
    end
  end
  if not l_65_2 then
    for id,cfg in pairs(cfgfx) do
      local pre = string.sub(id, 1, 1)
      if pre == "2" or pre == "3" then
        fxNames[cfg.name] = true
      end
    end
  end
  do
    local pngNames = tablecp(fxNames)
    for fxName,_ in pairs(fxNames) do
      if fxName:endwith("_start") then
        pngNames[fxName:sub(1, -7)] = true
        for fxName,_ in (for generator) do
        end
        if fxName:endwith("_loop") then
          pngNames[fxName:sub(1, -6)] = true
          for fxName,_ in (for generator) do
          end
          if fxName:endwith("_end") then
            pngNames[fxName:sub(1, -5)] = true
          end
        end
        pngNames.common = true
        for name,_ in pairs(pngNames) do
          local i = 1
          repeat
            repeat
              local texture = baseDir .. "spine_fight_" .. name .. "_" .. i .. ".png"
              local plist = baseDir .. "spine_fight_" .. name .. "_" .. i .. ".plist"
              local fullpath = CCFileUtils:sharedFileUtils():fullPathForFilename(texture)
              if CCFileUtils:sharedFileUtils():isFileExist(fullpath) then
                loadlist[#loadlist + 1] = {texture = texture, plist = plist}
                i = i + 1
                do return end
                for name,_ in (for generator) do
              else
                end
                return loadlist
              end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

img.getLoadListForPet = function(l_66_0)
  local cfgskill = require("config.skill")
  local cfgfx = require("config.fx")
  local loadlist = {}
  if not l_66_0 or #l_66_0 <= 0 then
    return loadlist
  end
  local cfgpet = require("config.pet")
  local petData = require("data.pet")
  local pngNames = {}
  do
    local uiNames = {}
    uiNames[#uiNames + 1] = "spine_ui_pet_1"
    uiNames[#uiNames + 1] = "spine_ui_pet_2"
    for ii = 1, #l_66_0 do
      local petid = l_66_0[ii].id
      local petInfo = petData.getData(petid)
      local petName = cfgpet[petid].petBody
      petName = string.sub(petName, 5, -2)
      if petName == "eagle" then
        petName = "griffin"
      elseif petName == "ice" then
        petName = "icesoul"
      end
      uiNames[#uiNames + 1] = string.format("spine_ui_%s%s", petName, l_66_0[ii].star + 1)
      local skills = {}
      local actSkillId = cfgpet[petid].actSkillId + l_66_0[ii].lv - 1
      skills[#skills + 1] = actSkillId
      local fxNames = {}
      for _,sk in ipairs(skills) do
        if sk then
          for _,f in ipairs({"fxSelf", "fxMain1", "fxMain2", "fxHurt1", "fxHurt2"}) do
            local fxes = cfgskill[sk][f]
            if fxes then
              for _,fx in ipairs(fxes) do
                fxNames[#fxNames + 1] = cfgfx[fx].name
              end
            end
          end
        end
      end
      for ii = 1, #fxNames do
        pngNames[#pngNames + 1] = string.format("%s", fxNames[ii])
      end
    end
    for jj = 1, #pngNames do
      local name = pngNames[jj]
      local i = 1
      repeat
        repeat
          local texture = baseDir .. "spine_fight_" .. name .. "_" .. i .. ".png"
          local plist = baseDir .. "spine_fight_" .. name .. "_" .. i .. ".plist"
          local fullpath = CCFileUtils:sharedFileUtils():fullPathForFilename(texture)
          if CCFileUtils:sharedFileUtils():isFileExist(fullpath) then
            loadlist[#loadlist + 1] = {texture = texture, plist = plist}
            i = i + 1
            do return end
            do return end
        else
          end
          for jj = 1, #uiNames do
            local name = uiNames[jj]
            local texture = baseDir .. name .. ".png"
            local plist = baseDir .. name .. ".plist"
            local fullpath = CCFileUtils:sharedFileUtils():fullPathForFilename(texture)
            if CCFileUtils:sharedFileUtils():isFileExist(fullpath) then
              loadlist[#loadlist + 1] = {texture = texture, plist = plist}
            end
          end
          return loadlist
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

img.getLoadListForSkin = function(l_67_0)
  local cfgequip = require("config.equip")
  local cfgfx = require("config.fx")
  local loadlist = {}
  local fxNames = {}
  for ii = 1, #l_67_0 do
    local unitResId = cfgequip[l_67_0[ii]].heroBody
    loadlist[#loadlist + 1] = {texture = baseDir .. img.packedUnit[unitResId] .. ".png", plist = baseDir .. img.packedUnit[unitResId] .. ".plist"}
    local cfg = cfgequip[l_67_0[ii]]
    for _,f in ipairs({"fxSelf", "fxMain1", "fxMain2", "fxHurt1", "fxHurt2"}) do
      local fxes = cfg[f]
      if fxes then
        for _,fx in ipairs(fxes) do
          if cfgfx[fx].resName then
            fxNames[#fxNames + 1] = cfgfx[fx].resName
            for _,fx in (for generator) do
            end
            fxNames[#fxNames + 1] = cfgfx[fx].name
          end
        end
      end
    end
    do
      local pngNames = {}
      for ii = 1, #fxNames do
        pngNames[#pngNames + 1] = string.format("%s", fxNames[ii])
      end
      for jj = 1, #pngNames do
        local name = pngNames[jj]
        local i = 1
        repeat
          repeat
            local texture = baseDir .. "spine_fight_" .. name .. "_" .. i .. ".png"
            local plist = baseDir .. "spine_fight_" .. name .. "_" .. i .. ".plist"
            local fullpath = CCFileUtils:sharedFileUtils():fullPathForFilename(texture)
            if CCFileUtils:sharedFileUtils():isFileExist(fullpath) then
              loadlist[#loadlist + 1] = {texture = texture, plist = plist}
              i = i + 1
              do return end
              do return end
          else
            end
            return loadlist
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

img.loadAsync = function(l_68_0, l_68_1)
  for _,info in ipairs(l_68_0) do
    do
      textureCache:addImageAsync(info.texture, function()
        if info.plist then
          spriteframeCache:addSpriteFramesWithFile(info.plist)
        else
          if info.frame then
            local tex = textureCache:textureForKey(info.texture)
            local size = tex:getContentSize()
            local rect = CCRect(0, 0, size.width, size.height)
            local frame = CCSpriteFrame:createWithTexture(tex, rect)
            spriteframeCache:addSpriteFrame(frame, info.frame)
          end
        end
        if handler then
          handler()
        end
         end)
    end
  end
end

img.unloadList = function(l_69_0)
  for _,info in ipairs(l_69_0) do
    local fightflag = false
    local names = tablevalues(img.packedUIFight)
    for ii,name in ipairs(names) do
      local plist = baseDir .. name .. ".plist"
      if info.plist == plist then
        fightflag = true
    else
      end
    end
    if fightflag == false then
      if info.plist then
        spriteframeCache:removeSpriteFramesFromFile(info.plist)
      end
      if info.frame then
        spriteframeCache:removeSpriteFrameByName(info.frame)
      end
      if info.texture then
        textureCache:removeTextureForKey(info.texture)
      end
    end
  end
end

return img

