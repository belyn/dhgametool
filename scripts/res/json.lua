-- Command line was: E:\github\dhgametool\scripts\res\json.lua 

local json = {}
require("common.const")
require("common.func")
local cache = DHSkeletonDataCache:getInstance()
json.fight = {shake = "spinejson/fight/shake.json"}
json.ui = {button = "spinejson/ui/btn.json", start = "spinejson/ui/homepage_new.json", main_zhuchangjing = "spinejson/ui/main_zhuchangjing_winter.json", main_diaoqiao = "spinejson/ui/main_diaoqiao_winter.json", main_yuanzheng = "spinejson/ui/main_yuanzheng_winter.json", main_yun = "spinejson/ui/main_yun_winter.json", main_yun2 = "spinejson/ui/main_yun2_winter.json", yindao = "spinejson/ui/yindao_girl.json", yd_hand = "spinejson/ui/yd_hand.json", bt_numbers = "spinejson/ui/bt_numbers.json", bt_tiao = "spinejson/ui/bt_tiao.json", zhandou_win = "spinejson/ui/victory.json", zhandou_lose = "spinejson/ui/defeat.json", main_zhanzhengzm = "spinejson/ui/main_zhanyi_winter.json", zhaohuan = "spinejson/ui/zhaohuan.json", toukui = "spinejson/ui/toukui.json", nengliangxi = "spinejson/ui/toukui.json", zhaohuan_lizihua = "spinejson/ui/zhaohuan_lizihua.json", zhaohuan_kuozhan = "spinejson/ui/zhaohuan_kuozhan.json", zhaohuan_zhen = "spinejson/ui/zhaohuan_zhen.json", zhaohuan_fazhen = "spinejson/ui/zhaohuan_fazhen.json", zhaohuan_fazhen_s = "spinejson/ui/zhaohuan_fazhen_s.json", zhaohuan_nenglcao = "spinejson/ui/zhaohuan_nenglcao.json", zhaohuan_toukuicx = "spinejson/ui/zhaohuan_toukuicx.json", blacksmith = "spinejson/ui/blacksmith.json", blacksmith_hecheng = "spinejson/ui/blacksmith_hecheng.json", reward = "spinejson/ui/reward.json", reward_particle = "spinejson/ui/reward_particle.json", duchang = "spinejson/ui/duchang.json", chongwu = "spinejson/ui/chongwu.json", tunvlang = "spinejson/ui/tunvlang.json", duchang_new = "spinejson/ui/duchang_new.json", chongwu_new = "spinejson/ui/chongwu_new.json", tunvlang_new = "spinejson/ui/tunvlang_new.json", hook = "spinejson/ui/hook.json", hook_reward_01 = "spinejson/ui/hook_reward_01.json", hook_reward_02 = "spinejson/ui/hook_reward_02.json", hook_reward_03 = "spinejson/ui/hook_reward_03.json", hook_pariticle = "spinejson/ui/hook_pariticle.json", hook_baoxiang = "spinejson/ui/hook_baoxiang.json", guaji_xuanguan = "spinejson/ui/guaji_xuanguan.json", guaji_green_btn = "spinejson/ui/guaji_green_btn.json", guaji_red_btn = "spinejson/ui/guaji_red_btn.json", guaji_yellow_btn = "spinejson/ui/guaji_yellow_btn.json", guild = "spinejson/ui/guild.json", fuben = "spinejson/ui/fuben.json", guildwar = "spinejson/ui/guildwar.json", keji = "spinejson/ui/keji.json", bbq = "spinejson/ui/bbq.json", mofang = "spinejson/ui/mofang.json", shop = "spinejson/ui/shop.json", radar = "spinejson/ui/radar.json", equip_in = "spinejson/ui/equip_in.json", shengji = "spinejson/ui/shengji.json", jiesuo = "spinejson/ui/jiesuo.json", devour = "spinejson/ui/devour.json", devour_fx = "spinejson/ui/devour_fx.json", devour_reward = "spinejson/ui/devour_reward.json", main_heishi = "spinejson/ui/main_heishi_winter.json", main_jiuguan = "spinejson/ui/main_jiuguan_winter.json", main_tunshi = "spinejson/ui/main_tunshi_winter.json", main_zhaohuan = "spinejson/ui/main_zhaohuan_winter.json", main_duchang = "spinejson/ui/main_duchang_winter.json", main_tiejiangpu = "spinejson/ui/main_tiejiangpu_winter.json", main_jjc = "spinejson/ui/main_jjc_winter.json", main_huanjing = "spinejson/ui/main_chengbao_winter.json", main_tree = "spinejson/ui/main_zhongjing_winter.json", main_summoning = "spinejson/ui/main_hecheng_winter.json", main_feiting = "spinejson/ui/main_feiting.json", main_hongshu = "spinejson/ui/main_hongshu_winter.json", main_dilao = "spinejson/ui/main_dilao_winter.json", main_seal_land = "spinejson/ui/main_shijianliefeng_winter.json", main_bg = "spinejson/ui/main_bg.json", winter_main_snow1 = "spinejson/ui/winter_main_snow1.json", winter_main_snow2 = "spinejson/ui/winter_main_snow2.json", huanjingta_floor1 = "spinejson/ui/huanjingta_floor1.json", huanjingta_floor2 = "spinejson/ui/huanjingta_floor2.json", huanjingta_mogu = "spinejson/ui/huanjingta_mogu.json", huanjingta = "spinejson/ui/huanjingta.json", dianjin = "spinejson/ui/dianjin.json", dianjin2 = "spinejson/ui/dianjin2.json", heishishangren = "spinejson/ui/heishishangren.json", heishi = "spinejson/ui/heishi.json", gonghui_shengji = "spinejson/ui/gonghui_shengji.json", gonghui_jiesuo = "spinejson/ui/gonghui_jiesuo.json", lag_loading = "spinejson/ui/lag_loading.json", mailbox = "spinejson/ui/mailbox.json", bt_1 = "spinejson/ui/bt_1.json", bt_2 = "spinejson/ui/bt_2.json", bt_3 = "spinejson/ui/bt_3.json", bt_4 = "spinejson/ui/bt_4.json", bt_5 = "spinejson/ui/bt_5.json", bt_6 = "spinejson/ui/bt_6.json", bt_7 = "spinejson/ui/bt_7.json", bt_8 = "spinejson/ui/bt_8.json", bt_9 = "spinejson/ui/bt_9.json", bt_10 = "spinejson/ui/bt_10.json", bt_11 = "spinejson/ui/bt_11.json", bt_12 = "spinejson/ui/bt_12.json", bt_diyu = "spinejson/ui/bt_diyu.json", bt_cloud_diyu = "spinejson/ui/bt_cloud_diyu.json", bt_lock_weizhi_diyu = "spinejson/ui/bt_lock_weizhi_diyu.json", bt_pubu = "spinejson/ui/bt_pubu.json", bt_pubu = "spinejson/ui/bt_pubu.json", bt_pubu = "spinejson/ui/bt_pubu.json", bt_all = "spinejson/ui/bt_all.json", bt_all_kunnan = "spinejson/ui/bt_all_kunnan.json", hero_up = "spinejson/ui/hero_up.json", hero_star = "spinejson/ui/hero_star.json", hero_et = "spinejson/ui/hero_up_new.json", hero_bg1 = "spinejson/ui/hero_bg1.json", hero_bg2 = "spinejson/ui/hero_bg2.json", hero_bg3 = "spinejson/ui/hero_bg3.json", hero_bg4 = "spinejson/ui/hero_bg4.json", hero_bg5 = "spinejson/ui/hero_bg5.json", hero_bg6 = "spinejson/ui/hero_bg6.json", clock = "spinejson/ui/clock.json", ic_refresh = "spinejson/ui/ic_refresh.json", ic_vip = "spinejson/ui/ic_vip.json", daojishi = "spinejson/ui/daojishi.json", jjc = "spinejson/ui/jjc.json", jg_btn = "spinejson/ui/jg_btn.json", bt_cloud = "spinejson/ui/bt_cloud.json", bt_cloud_kunnan = "spinejson/ui/bt_cloud_kunnan.json", bt_lock = "spinejson/ui/bt_lock.json", qianghua = "spinejson/ui/qianghua.json", bt_lock_weizhi = "spinejson/ui/bt_lock_weizhi.json", bt_sword = "spinejson/ui/bt_sword.json", gh_chengbao_fx = "spinejson/ui/gh_chengbao_fx.json", zhaohuan_lizi = "spinejson/ui/zhaohuan_lizi.json", haoyou_heart = "spinejson/ui/haoyou_heart.json", hero_numbers = "spinejson/ui/hero_numbers.json", campbuff = {"spinejson/ui/jjc_kulou.json", "spinejson/ui/jjc_baolei.json", "spinejson/ui/jjc_shenyuan.json", "spinejson/ui/jjc_senlin.json", "spinejson/ui/jjc_anying.json", "spinejson/ui/jjc_shengguang.json", "spinejson/ui/jjc_hunhe.json", "spinejson/ui/jjc_zhengxie.json", "spinejson/ui/jjc_huimie.json", "spinejson/ui/jjc_jiushu.json", "spinejson/ui/jjc_zhengyi.json", "spinejson/ui/jjc_xiee.json", "spinejson/ui/jjc_wuran.json", "spinejson/ui/jjc_shuhun.json", "spinejson/ui/jjc_shengyusi.json", "spinejson/ui/jjc_sudi.json"}, tiejiangpu_shengji_fx = "spinejson/ui/tiejiangpu_shengji_fx.json", devour_fx_v2 = "spinejson/ui/devour_fx_v2.json", devour_in_animation = "spinejson/ui/devour_in_animation.json", devour_particle_animation = "spinejson/ui/devour_particle_animation.json", pvp_choujiang = "spinejson/ui/PVP_choujiang.json", yingxiong_hecheng = "spinejson/ui/yingxiong_hecheng.json", yingxiong_hecheng_shake = "spinejson/ui/yingxiong_hecheng_shake.json", yingxiong_hecheng2 = "spinejson/ui/yingxiong_hecheng2.json", yingxiong_hecheng_animation_in = "spinejson/ui/yingxiong_hecheng_animation_in.json", bt_lock_weizhi_kunnan = "spinejson/ui/bt_lock_weizhi_kunnan.json", haoyouzhuzhan = "spinejson/ui/haoyouzhuzhan.json", baoshi_hecheng = "spinejson/ui/baoshi_hecheng.json", yingxiongmianban = "spinejson/ui/yingxiongmianban.json", yingxiongmianban_weizhi = "spinejson/ui/yingxiongmianban_weizhi.json", yuanzheng_caozuojiemian = "spinejson/ui/yuanzheng_caozuojiemian.json", yuanzheng_fight = "spinejson/ui/yuanzheng_fight.json", yuanzheng_jiemian = "spinejson/ui/yuanzheng_jiemian.json", yuanzheng_path = "spinejson/ui/yuanzheng_path.json", yuanzheng = "spinejson/ui/yuanzheng.json", p3v3jiesuan = "spinejson/ui/3v3jiesuan.json", p3v3jiesuan_v = "spinejson/ui/3v3jiesuan_victory.json", p3v3jiesuan_d = "spinejson/ui/3v3jiesuan_defeat.json", jjc2 = "spinejson/ui/jjc2.json", zhuangbei_shengji = "spinejson/ui/zhuangbei_shengji.json", baowu_line = "spinejson/ui/baowu_line.json", baowu_upgrade = "spinejson/ui/baowu_upgrade.json", baowu_upgrade2 = "spinejson/ui/baowu_upgrade2.json", mofang_mofangline = "spinejson/ui/mofang_mofangline.json", mofang_smk = "spinejson/ui/mofang_smk.json", mofang_upgrade_down = "spinejson/ui/mofang_upgrade_down.json", mofang_upgrade_up = "spinejson/ui/mofang_upgrade_up.json", mofang_upgrade_huxi = "spinejson/ui/mofang_upgrade_huxi.json", mofang_upgrade_line = "spinejson/ui/mofang_upgrade_line.json", shengmingzhishu_1 = "spinejson/ui/shengmingzhishu_1.json", shengmingzhishu_2 = "spinejson/ui/shengmingzhishu_2.json", shengmingzhishu_3 = "spinejson/ui/shengmingzhishu_3.json", shengmingzhishu_4 = "spinejson/ui/shengmingzhishu_4.json", shengmingzhishu_5 = "spinejson/ui/shengmingzhishu_5.json", shengmingzhishu_animation = "spinejson/ui/shengmingzhishu_animation.json", shengmingzhishu_bottom = "spinejson/ui/shengmingzhishu_bottom.json", shengmingzhishu_light = "spinejson/ui/shengmingzhishu_light.json", shengmingzhishu_top = "spinejson/ui/shengmingzhishu_top.json", zhihuan = "spinejson/ui/zhihuan.json", yuanzheng_baoxiang = "spinejson/ui/yuanzheng_baoxiang.json", yuanzheng_baoxiang_gem = "spinejson/ui/yuanzheng_baoxiang_gem.json", sheng_xing1 = "spinejson/ui/sheng_xing1.json", sheng_xing2 = "spinejson/ui/sheng_xing2.json", praise = "spinejson/ui/praise.json", guildwar_ui = "spinejson/ui/guildwar_ui.json", bt_dot_easy = "spinejson/ui/bt_dot_easy.json", bt_dot_hard = "spinejson/ui/bt_dot_hard.json", bt_dot_hell = "spinejson/ui/bt_dot_hell.json", jiuguan_refresh = "spinejson/ui/jiuguan_refresh.json", yindao_new = "spinejson/ui/yindao_girl.json", yindao_face = "spinejson/ui/yindao_face.json", frd_jjc = "spinejson/ui/3v3_jjc.json", pet_json = "spinejson/ui/zhanchong.json", pet2_json = "spinejson/ui/zhanchong_2.json", pet_play_json = "spinejson/ui/pet_play.json", exp_battle = "spinejson/ui/exp_battle.json", exp_battle2 = "spinejson/ui/exp_battle2.json", spine_dragon_1 = "spinejson/ui/dragon1.json", spine_dragon_2 = "spinejson/ui/dragon2.json", spine_dragon_3 = "spinejson/ui/dragon3.json", spine_dragon_4 = "spinejson/ui/dragon4.json", spine_fox_1 = "spinejson/ui/fox1.json", spine_fox_2 = "spinejson/ui/fox2.json", spine_fox_3 = "spinejson/ui/fox3.json", spine_fox_4 = "spinejson/ui/fox4.json", spine_deer_1 = "spinejson/ui/deer1.json", spine_deer_2 = "spinejson/ui/deer2.json", spine_deer_3 = "spinejson/ui/deer3.json", spine_deer_4 = "spinejson/ui/deer4.json", spine_eagle_1 = "spinejson/ui/griffin1.json", spine_eagle_2 = "spinejson/ui/griffin2.json", spine_eagle_3 = "spinejson/ui/griffin3.json", spine_eagle_4 = "spinejson/ui/griffin4.json", spine_wolf_1 = "spinejson/ui/wolf1.json", spine_wolf_2 = "spinejson/ui/wolf2.json", spine_wolf_3 = "spinejson/ui/wolf3.json", spine_wolf_4 = "spinejson/ui/wolf4.json", spine_stone_1 = "spinejson/ui/stone1.json", spine_stone_2 = "spinejson/ui/stone2.json", spine_stone_3 = "spinejson/ui/stone3.json", spine_stone_4 = "spinejson/ui/stone4.json", spine_viper_1 = "spinejson/ui/viper1.json", spine_viper_2 = "spinejson/ui/viper2.json", spine_viper_3 = "spinejson/ui/viper3.json", spine_viper_4 = "spinejson/ui/viper4.json", spine_ice_1 = "spinejson/ui/icesoul1.json", spine_ice_2 = "spinejson/ui/icesoul2.json", spine_ice_3 = "spinejson/ui/icesoul3.json", spine_ice_4 = "spinejson/ui/icesoul4.json", pet_fx = "spinejson/ui/pet_fx.json", touxiang = "spinejson/ui/touxiang.json", huodong = "spinejson/ui/huodong.json", solo = "spinejson/ui/1on1.json", solo_up = "spinejson/ui/1on1_up.json", solo_down = "spinejson/ui/1on1_down.json", solo_side = "spinejson/ui/1on1_side.json", solo_btn = "spinejson/ui/dantiaosai.json", solo_speed = "spinejson/ui/1on1_1speed_click_side.json", solo_power = "spinejson/ui/1on1_2power_click_side.json", solo_crit = "spinejson/ui/1on1_3cc_click_side.json", solo_auto = "spinejson/ui/1on1_auto_fight_side.json", solo_lightA = "spinejson/ui/dantiaosai_zengjiaA.json", solo_lightB = "spinejson/ui/dantiaosai_zengjiaB.json", solo_sweep = "spinejson/ui/sweep_ui.json", trader1 = "spinejson/ui/dts_shangren1.json", trader2 = "spinejson/ui/dts_shangren2.json", trader3 = "spinejson/ui/dts_shangren3.json", petHint = "spinejson/ui/pet_hint.json", bianshen = "spinejson/ui/bianshen.json", lv10_framefx = "spinejson/ui/lv10_framefx.json", unlock = "spinejson/ui/unlock.json", kongzhan = "spinejson/ui/kongzhan.json", kongzhan_xuanwo = "spinejson/ui/kongzhan_xuanwo.json", kongzhan_map = "spinejson/ui/kongzhan_map.json", kongzhan_map_yun = "spinejson/ui/kongzhan_map_yun.json", kongzhan_golem = "spinejson/ui/kongzhan_golem.json", kongzhan_dragon = "spinejson/ui/kongzhan_dragon.json", kongzhan_dao1 = "spinejson/ui/kongzhan_dao1.json", kongzhan_dao2 = "spinejson/ui/kongzhan_dao2.json", kongzhan_dao3 = "spinejson/ui/kongzhan_dao3.json", kongzhan_diaoluo = "spinejson/ui/kongzhan_diaoluo.json", kongzhan_rk1 = "spinejson/ui/kongzhan_rk1_winter.json", kongzhan_rk2 = "spinejson/ui/kongzhan_rk2_winter.json", kongzhan_rk3 = "spinejson/ui/kongzhan_rk3_winter.json", kongzhan_zhudao = "spinejson/ui/kongzhan_zhudao.json", kongzhan_feiting = "spinejson/ui/kongzhan_feiting.json", kongzhan_baojun = "spinejson/ui/kongzhan_baojun.json", kongzhan_chengbao = "spinejson/ui/kongzhan_chengbao.json", kongzhan_jifeng = "spinejson/ui/kongzhan_jifeng.json", kongzhan_jinkuang = "spinejson/ui/kongzhan_jinkuang.json", kongzhan_shuijing = "spinejson/ui/kongzhan_shuijing.json", kongzhan_xueyue = "spinejson/ui/kongzhan_xueyue.json", kongzhan_mofachen = "spinejson/ui/kongzhan_mofachen.json", kongzhan_huoli = "spinejson/ui/kongzhan_huoli.json", kongzhan_fengshou = "spinejson/ui/kongzhan_fengshou.json", kongzhan_dizuo = "spinejson/ui/kongzhan_dizuo.json", kongzhan_zhudao_chaichu = "spinejson/ui/kongzhan_zhudao_chaichu.json", kongzhan_zhudao_jianzao = "spinejson/ui/kongzhan_zhudao_jianzao.json", kongzhan_zhudao_shengji = "spinejson/ui/kongzhan_zhudao_shengji.json", kongzhan_tish = "spinejson/ui/kongzhan_tishi.json", zhihuan_icon = "spinejson/ui/zhihuan_icon.json", npc_order = "spinejson/ui/npc_order.json", chinesenewyear = "spinejson/ui/chinesenewyear.json", gonghui_qidao = "spinejson/ui/gonghui_qidao.json", gear_ui = "spinejson/ui/gear_ui.json", gear_ui2 = "spinejson/ui/gear_ui2.json", double_icon = "spinejson/ui/double_icon.json", lv10plus_hero = "spinejson/ui/lv10plus_hero.json", cannon = "spinejson/ui/cannon.json", seal_land_door = "spinejson/ui/time_rent_disc.json", guoqing_qiandao1 = "spinejson/ui/guoqing_qiandao1.json", guoqing_qiandao2 = "spinejson/ui/guoqing_qiandao2.json", wanshengjie_bg = "spinejson/ui/wanshengjie_bg.json", wanshengjie_boss = "spinejson/ui/wanshengjie_boss.json", fengshoubaozhang = "spinejson/ui/fengshoubaozhang.json", fengshoubaozhang_click = "spinejson/ui/fengshoubaozhang_click.json", ganenwancan = "spinejson/ui/ganenwancan.json", shixingzhihuan = "spinejson/ui/shixingzhihuan.json", black = "spinejson/ui/black.json", christmas = "spinejson/ui/Christmas.json", chirstmas_greetingcard_boom = "spinejson/ui/chirstmas_greetingcard_boom.json", christmas_greetingcard01 = "spinejson/ui/christmas_greetingcard01.json", christmas_greetingcard02 = "spinejson/ui/christmas_greetingcard02.json", christmas_greetingcard03 = "spinejson/ui/christmas_greetingcard03.json", christmas_greetingcard04 = "spinejson/ui/christmas_greetingcard04.json", christmas_walk = "spinejson/ui/christmas_walk.json", christmas_card = "spinejson/ui/christmas_card.json", winter_main_snow5 = "spinejson/ui/winter_main_snow5.json", christmas_card_xinzhifly = "spinejson/ui/christmas_card_xinzhifly.json", christmas_card_baoxiangfx1 = "spinejson/ui/christmas_card_baoxiangfx1.json", christmas_card_baoxiangfx2 = "spinejson/ui/christmas_card_baoxiangfx2.json", christmas_card_baoxiangfx3 = "spinejson/ui/christmas_card_baoxiangfx3.json", christmas_card_baoxiangfx4 = "spinejson/ui/christmas_card_baoxiangfx4.json", christmas_card_baoxiangfx5 = "spinejson/ui/christmas_card_baoxiangfx5.json", christmas_card_baoxiangfx6 = "spinejson/ui/christmas_card_baoxiangfx6.json", christmas_card_baoxiangfx7 = "spinejson/ui/christmas_card_baoxiangfx7.json", christmas_card_baoxiangfx8 = "spinejson/ui/christmas_card_baoxiangfx8.json", christmas_baoxiang = "spinejson/ui/christmas_baoxiang.json", christmas_caiqi = "spinejson/ui/christmas_caiqi.json", christmas_huanhuan = "spinejson/ui/christmas_huanhuan.json", christmas_shengdanshu = "spinejson/ui/christmas_shengdanshu.json", christmas_xueren = "spinejson/ui/christmas_xueren.json", winter_main_snow_5 = "spinejson/ui/winter_main_snow5.json"}
json.mainUIWhitelist = {button = "spinejson/ui/btn.json", start = "spinejson/ui/homepage_new.json", main_zhuchangjing = "spinejson/ui/main_zhuchangjing_winter.json", main_diaoqiao = "spinejson/ui/main_diaoqiao_winter.json", main_yuanzheng = "spinejson/ui/main_yuanzheng_winter.json", main_yun = "spinejson/ui/main_yun_winter.json", main_yun2 = "spinejson/ui/main_yun2_winter.json", yindao = "spinejson/ui/yindao_girl.json", yd_hand = "spinejson/ui/yd_hand.json", main_zhanzhengzm = "spinejson/ui/main_zhanyi_winter.json", zhaohuan = "spinejson/ui/zhaohuan.json", reward = "spinejson/ui/reward.json", reward_particle = "spinejson/ui/reward_particle.json", main_heishi = "spinejson/ui/main_heishi_winter.json", main_jiuguan = "spinejson/ui/main_jiuguan_winter.json", main_tunshi = "spinejson/ui/main_tunshi_winter.json", main_zhaohuan = "spinejson/ui/main_zhaohuan_winter.json", main_duchang = "spinejson/ui/main_duchang_winter.json", main_tiejiangpu = "spinejson/ui/main_tiejiangpu_winter.json", main_jjc = "spinejson/ui/main_jjc_winter.json", main_huanjing = "spinejson/ui/main_chengbao_winter.json", main_tree = "spinejson/ui/main_zhongjing_winter.json", main_summoning = "spinejson/ui/main_hecheng_winter.json", main_feiting = "spinejson/ui/main_feiting.json", main_hongshu = "spinejson/ui/main_hongshu_winter.json", main_dilao = "spinejson/ui/main_dilao_winter.json", main_seal_land = "spinejson/ui/main_shijianliefeng_winter.json", main_bg = "spinejson/ui/main_bg.json", winter_main_snow1 = "spinejson/ui/winter_main_snow1.json", winter_main_snow2 = "spinejson/ui/winter_main_snow2.json", lag_loading = "spinejson/ui/lag_loading.json", ic_refresh = "spinejson/ui/ic_refresh.json", ic_vip = "spinejson/ui/ic_vip.json", praise = "spinejson/ui/praise.json", yindao_new = "spinejson/ui/yindao_girl.json", yindao_face = "spinejson/ui/yindao_face.json", touxiang = "spinejson/ui/touxiang.json"}
json.isInList = function(l_1_0, l_1_1)
  for kk,vv in pairs(l_1_1) do
    if vv == l_1_0 then
      return true
    end
  end
  return false
end

json.unloadItem = function(l_2_0)
  if not l_2_0 then
    return 
  end
  if type(l_2_0) == "table" then
    for kk,vv in pairs(l_2_0) do
      json.unloadItem(vv)
    end
  else
    if not json.isInList(l_2_0, json.mainUIWhitelist) then
      json.unload(l_2_0)
    end
  end
end

json.unloadForTown = function()
  json.unloadAllUnits()
  json.unloadAllHeroBg()
  for kk,vv in pairs(json.ui) do
    json.unloadItem(vv)
  end
end

if APP_CHANNEL and APP_CHANNEL ~= "" then
  json.ui.start = "spinejson/ui/homepage_new.json"
end
json.unit = {}
local helper = require("common.helper")
local jsonQueue = require("dhcomponents.tools.List").new()
json.initUnits = function(l_4_0)
  for _,d in ipairs(l_4_0) do
    json.unit[d.id] = "spinejson/unit/cha_" .. d.str .. ".json"
  end
end

json.createSpineHero = function(l_5_0)
  local cfghero = require("config.hero")
  json.loadUnit(cfghero[l_5_0].heroBody)
  local hero = DHSkeletonAnimation:createWithKey(json.unit[cfghero[l_5_0].heroBody])
  hero:scheduleUpdateLua()
  hero:playAnimation("stand", -1)
  if cfghero[l_5_0].heroskin then
    hero:registerSkin(cfghero[l_5_0].heroskin)
  end
  if cfghero[l_5_0].anims then
    for i = 1,  cfghero[l_5_0].anims do
      local jsonname = "spinejson/unit/" .. cfghero[l_5_0].anims[i] .. ".json"
      json.load(jsonname)
      local heroloop = DHSkeletonAnimation:createWithKey(jsonname)
      heroloop:scheduleUpdateLua()
      heroloop:playAnimation("animation", -1)
      hero:addChildFollowSlot(cfghero[l_5_0].anims[i], heroloop)
    end
  end
  return hero
end

json.createSpineHeroSkin = function(l_6_0)
  local cfgequip = require("config.equip")
  json.loadUnit(cfgequip[l_6_0].heroBody)
  local hero = DHSkeletonAnimation:createWithKey(json.unit[cfgequip[l_6_0].heroBody])
  hero:scheduleUpdateLua()
  hero:playAnimation("stand", -1)
  if cfgequip[l_6_0].anims then
    for i = 1,  cfgequip[l_6_0].anims do
      local jsonname = "spinejson/unit/" .. cfgequip[l_6_0].anims[i] .. ".json"
      json.load(jsonname)
      local heroloop = DHSkeletonAnimation:createWithKey(jsonname)
      heroloop:scheduleUpdateLua()
      heroloop:playAnimation("animation", -1)
      hero:addChildFollowSlot(cfgequip[l_6_0].anims[i], heroloop)
    end
  end
  return hero
end

json.createSpineMons = function(l_7_0)
  local cfgmons = require("config.monster")
  return json.createSpineHero(cfgmons[l_7_0].heroLink)
end

json.create = function(l_8_0)
  json.load(l_8_0)
  local anim = DHSkeletonAnimation:createWithKey(l_8_0)
  anim:scheduleUpdateLua()
  return anim
end

json.createWithoutSchedule = function(l_9_0)
  json.load(l_9_0)
  local anim = DHSkeletonAnimation:createWithKey(l_9_0)
  return anim
end

json.load = function(l_10_0, l_10_1)
  if not cache:getSkeletonData(l_10_0) then
    if not l_10_1 and helper.getJsonCacheCount() < jsonQueue:size() then
      local valueKey = jsonQueue:front()
      json.unload(valueKey, true)
      jsonQueue:popFront()
    else
      cache:loadSkeletonData(l_10_0, l_10_0)
      jsonQueue:pushBack(l_10_0)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

json.unload = function(l_11_0, l_11_1)
  cache:removeSkeletonData(l_11_0)
  if not l_11_1 then
    local iter = jsonQueue:getBegin()
    repeat
      repeat
        if iter ~= jsonQueue:getEnd() then
          local valueKey = iter:getValue()
          if valueKey == l_11_0 then
            iter = jsonQueue:erase(iter)
            do return end
          else
            iter = iter:getNext()
          end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

json.loadUnit = function(l_12_0)
  local img = require("res.img")
  img.loadUnit(l_12_0)
  json.load(json.unit[l_12_0])
end

json.unloadUnit = function(l_13_0)
  local img = require("res.img")
  img.unloadUnit(l_13_0)
  json.unload(json.unit[l_13_0])
end

json.unloadAllUnits = function()
  for _,name in pairs(json.unit) do
    json.unload(name)
  end
  local img = require("res.img")
  img.unloadAllUnits()
end

json.unloadAllHeroBg = function()
  for ii = 1, 6 do
    json.unload(json.ui.hero_bg" .. i)
  end
end

json.loadSummon = function()
  local img = require("res.img")
  for _,name in pairs(img.packedOthers.spine_ui_summon) do
    img.load(name)
  end
  json.load(json.ui.summon)
  json.load(json.ui.summon_avatar)
end

json.unloadSummon = function()
  json.unload(json.ui.summon)
  local img = require("res.img")
  for _,name in pairs(img.packedOthers.spine_ui_summon) do
    img.unload(name)
  end
end

json.loadDevour = function()
  local img = require("res.img")
  for _,name in pairs(img.packedOthers.spine_ui_devour) do
    img.load(name)
  end
  for _,name in pairs(json.ui.devour) do
    json.load(name)
  end
end

json.unloadDevour = function()
  for _,name in pairs(json.ui.devour) do
    json.unload(name)
  end
  local img = require("res.img")
  for _,name in pairs(img.packedOthers.spine_ui_devour) do
    img.unload(name)
  end
end

json.getLoadListForUI = function()
  local loadlist = {}
  return loadlist
end

json.keyForFight = function(l_21_0)
  return "spinejson/fight/" .. l_21_0 .. ".json"
end

json.getAllBuff = function()
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
  for fxName,_ in pairs(fxNames) do
    loadlist[ loadlist + 1] = json.keyForFight(fxName)
  end
  for _,p in pairs(json.fight) do
    loadlist[ loadlist + 1] = p
  end
  return loadlist
end

json.getLoadListForFight = function(l_23_0, l_23_1)
  local cfghero = require("config.hero")
  local cfgskill = require("config.skill")
  local cfgfx = require("config.fx")
  local loadlist = {}
  for _,id in ipairs(l_23_0) do
    local unitResId = cfghero[id].heroBody
    loadlist[ loadlist + 1] = json.unit[unitResId]
    if cfghero[id].anims then
      for i = 1,  cfghero[id].anims do
        local jsonname = "spinejson/unit/" .. cfghero[id].anims[i] .. ".json"
        loadlist[ loadlist + 1] = jsonname
      end
    end
  end
  local fxNames = {}
  if not l_23_1 then
    for id,cfg in pairs(cfgfx) do
      local pre = string.sub(id, 1, 1)
      if pre == "2" or pre == "3" then
        fxNames[cfg.name] = true
      end
    end
  end
  local skArray = nil
  if l_23_1 then
    skArray = 
  else
    skArray = 
  end
  for _,id in {"atkId"}(l_23_0) do
    for _,s in ipairs(skArray) do
      local sk = cfghero[id][s]
      if sk then
        for _,f in ipairs({"fxSelf", "fxMain1", "fxMain2", "fxHurt1", "fxHurt2"}) do
          local fxes = cfgskill[sk][f]
          if fxes then
            for _,fx in ipairs(fxes) do
              fxNames[cfgfx[fx].name] = true
            end
          end
        end
      end
    end
  end
  for fxName,_ in pairs(fxNames) do
    loadlist[ loadlist + 1] = json.keyForFight(fxName)
  end
  for _,p in pairs(json.fight) do
    loadlist[ loadlist + 1] = p
  end
  return loadlist
end

json.getLoadListForFight2 = function(l_24_0, l_24_1)
  local cfgequip = require("config.equip")
  local cfghero = require("config.hero")
  local cfgskill = require("config.skill")
  local cfgfx = require("config.fx")
  local herosdata = require("data.heros")
  local loadlist = {}
  local fxNames = {}
  for _,hInfo in ipairs(l_24_0) do
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
    loadlist[ loadlist + 1] = json.unit[unitResId]
    local anims = cfghero[hInfo.id].anims
    if (hInfo.skin and cfgequip[hInfo.skin] and cfgequip[hInfo.skin].anims) or anims then
      for i = 1,  anims do
        local jsonname = "spinejson/unit/" .. anims[i] .. ".json"
        loadlist[ loadlist + 1] = jsonname
      end
    end
    local skills = {}
    local skArray = nil
    if l_24_1 then
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
  local fxNames = {}
  if not l_24_1 then
    for id,cfg in pairs(cfgfx) do
      local pre = string.sub(id, 1, 1)
      if pre == "2" or pre == "3" then
        fxNames[cfg.name] = true
      end
    end
  end
  for fxName,_ in pairs(fxNames) do
    loadlist[ loadlist + 1] = json.keyForFight(fxName)
  end
  for _,p in pairs(json.fight) do
    loadlist[ loadlist + 1] = p
  end
  return loadlist
end

json.getLoadListForPet = function(l_25_0)
  local cfgskill = require("config.skill")
  local cfgfx = require("config.fx")
  local loadlist = {}
  if not l_25_0 or  l_25_0 <= 0 then
    return loadlist
  end
  local cfgpet = require("config.pet")
  local pngNames = {}
  for ii = 1,  l_25_0 do
    local petid = l_25_0[ii].id
    local skills = {}
    local actSkillId = cfgpet[petid].actSkillId + l_25_0[ii].lv - 1
    skills[ skills + 1] = actSkillId
    local fxNames = {}
    for _,sk in ipairs(skills) do
      if sk then
        for _,f in ipairs({"fxSelf", "fxMain1", "fxMain2", "fxHurt1", "fxHurt2"}) do
          local fxes = cfgskill[sk][f]
          if fxes then
            for _,fx in ipairs(fxes) do
              fxNames[ fxNames + 1] = cfgfx[fx].name
            end
          end
        end
      end
    end
    for ii = 1,  fxNames do
      loadlist[ loadlist + 1] = json.keyForFight(fxNames[ii])
    end
  end
  return loadlist
end

json.getLoadListForSkin = function(l_26_0)
  local cfgequip = require("config.equip")
  local cfgfx = require("config.fx")
  local loadlist = {}
  local fxNames = {}
  for ii = 1,  l_26_0 do
    local unitResId = cfgequip[l_26_0[ii]].heroBody
    loadlist[ loadlist + 1] = json.unit[unitResId]
    local cfg = cfgequip[l_26_0[ii]]
    for _,f in ipairs({"fxSelf", "fxMain1", "fxMain2", "fxHurt1", "fxHurt2"}) do
      local fxes = cfg[f]
      if fxes then
        for _,fx in ipairs(fxes) do
          fxNames[ fxNames + 1] = cfgfx[fx].name
        end
      end
    end
  end
  for ii = 1,  fxNames do
    loadlist[ loadlist + 1] = json.keyForFight(fxNames[ii])
  end
  return loadlist
end

json.loadAll = function(l_27_0)
  for _,name in ipairs(l_27_0) do
    json.load(name, true)
  end
end

json.unloadAll = function(l_28_0)
  for _,name in ipairs(l_28_0) do
    json.unload(name, true)
  end
end

return json

