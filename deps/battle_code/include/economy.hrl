-record(economy,{
	gd_accountId        = 0,
	gd_silver           = 0,
	gd_junliang			= 0,		%% 军粮
	gd_gold             = 0,		%% 非绑定元宝
	gd_bind_gold        = 0,		%% 绑定元宝
	gd_practice         = 0,		%% 阅历
	gd_popularity       = 0, 		%% 军功（先留着，目前没用了）
	gd_tot_popularity   = 0,		%% 累计总军功（先留着，目前没用了）
	gd_reputation       = 0, 		%% 声望
	gd_tot_reputation   = 0,		%% 累计总声望
	gd_junwei           = 0,		%% 君威
	gd_honour_score     = 0,		%% 当前荣誉积分
	gd_tot_honour_score = 0, 	%% 累计荣誉积分
	gd_school_point     = 0,		%% 当前师门积分
	gd_king_point       = 0,		%% 守卫国王积分
	gd_tower_point		= 0,		%% 爬塔积分
	gd_guild_point		= 0,		%% 公会积分
	gd_tot_guild_point	= 0,		%% 公会历史积分
	gd_sword_point		= 0,		%% 神剑积分
	gd_lingli           = 0,		%% 灵力（求求暂时不要用啊，用了后果自负）
    gd_gold_arrow       = 0,		%% 黄金箭（帮派活动中用的）
    gd_hunt_point		= 0,		%% 狩猎积分
    gd_manor_point 		= 0,		%% 领地战积分
	gd_pk_point 		= 0,		%% 跨服竞技场积分
	gd_cave_point		= 0,		%% 藏宝洞积分
	gd_cross_point		= 0,		%% 跨服积分
	gd_tower2_point	 	= 0,		%% 新爬塔积分
	gd_arena_point		= 0,		%% 竞技场积分
	gd_mys_point 		= 0 		%% 神秘商店积分
	}).

-record(economy_types,{
	gd_accountId        = {integer},
	gd_silver           = {integer},
	gd_junliang			= {integer},
	gd_gold             = {integer},
	gd_bind_gold        = {integer},
	gd_practice         = {integer},
	gd_popularity       = {integer},
	gd_tot_popularity   = {integer},
	gd_reputation       = {integer},
	gd_tot_reputation   = {integer},
	gd_junwei           = {integer},
	gd_honour_score     = {integer},
	gd_tot_honour_score = {integer},
	gd_school_point     = {integer},
	gd_king_point       = {integer},
	gd_tower_point		= {integer},
	gd_guild_point		= {integer},
	gd_tot_guild_point	= {integer},
	gd_sword_point		= {integer},
	gd_lingli           = {integer},
    gd_gold_arrow       = {integer},
    gd_hunt_point	  	= {integer},
    gd_manor_point 		= {integer},
	gd_pk_point			= {integer},
	gd_cave_point		= {integer},
	gd_cross_point	 	= {integer},
	gd_tower2_point		= {integer},
	gd_arena_point		= {integer},
	gd_mys_point		= {integer}
	}).


-define(ETS_ECONOMY,ets_economy).

-define(DISPLAY,1).
-define(NOT_DISPLAY,0).


