%% ======================= 本gen_cache的主要特性：=========================
%% 1.将sql数据库中对应的表自动转为erlang中与之对应的record，并将数据缓存到ets表中
%% 2.支持将数据插入、更新和删除到ets表中
%% 3.支持定时同步数据到数据库中，并且可以定制缓存执行的间隔时间
%% 3.支持最多3个关键字的数据库表转化到ets表


%% ======================== 使用说明：==================================
%% 1.前提之一是数据库表中的字段名要与对应的ets表的record记录的字段完全一致
%% 2.为每一个与数据库表对应的record：xxx，定义一个record：xxx_types
%% 		对应record的字段的类别定义：格式：{Type} 
%%		type -> integer | string | term
%%		对应type的字段从数据库中读取出来时会自动做好转换的
%%		例子如下：
%% 		-record(player, {id = 0,
%%				 x = 0,
%%				 y = 0,
%%				 scene = 0,
%%				 name = ""
%%				 }).
%%		-record(player_types, {id = {integer},
%%			   x = {integer},
%%			   y = {integer},
%%			   scene = {integer},
%%			   name = {string} 
%%			   }).
%%		请注意要一定保持record和record_types字段名的顺序要以一定对应
%% 3.关于关键字类别：(重要：目前不支持除整型以外的关键字，如果要做的话，要完成cache_util模块中的TODO)
%%		1)：record的第一个字段为关键字，且key_fields中只有一个字段名
%%		2)：record的第一个字段为关键字，且key_fields中有2个字段名，用元祖表示{key1, key2}
%%		3)：record的第一个字段为关键字，且key_fields中有3个字段名，用元祖表示{key1, key2, key3}
%% 4.定义gen_cache_state对象
%% 5.使用gen_cache来start_link/1或start/1方法启动进程
%% 6.调用gen_cache的增删查改方法
%% 7.ignored_fields的使用：在record中存在，但不存在于数据库的fields，需要按顺序排列在record的最后面
%% 8.gen_cache_state记录中的call_back字段定义了gen_cache在做“增删查改”操作时能支持用户自定义回调函数
%%    使用时需要将记录gen_cache_call_back作为call_back字段的值
%%	  Be careful! This feature is not tested! Use this of your risk!

-record(map, {ets_tab = none,	%% 对应的ets表
			  sql_tab = "",		%% 对应的sql
			  key_classic = 1,	%% 表关键字的类别
			  key_fields = [],	%% slq关键字的名称列表
			  fields = [],		%% ets表中的所有字段名
			  fields_spec,		%% 该map中的记录所对应的xxx_types记录
			  ignored_fields = [] %% fields中该忽略掉的字段
			  }).

-record(gen_cache_state, {record,				%% gen_cache对应的ets中的record，如player
						  mapper,				%% 对应于map记录
						  cache_ref,			%% 该缓存的注册名称，没有注册则为pid(TODO：目前还每支持飞注册进程)
						  update_index,			%% gen_cache对应的ets中做了修改了记录的索引
						  update_interval = 5*60000, %% 缓存数据更新到数据库的间隔(ms)
						  call_back,				%% gen_cache增删查改4个方法对应的call_back函数
  						  update_timer = undefined,
						  lookup_counter = 0,		%%查找次数
						  insert_counter = 0,        %%插入次数
						  update_counter = 0,		%%更新次数
						  delete_counter = 0		%%删除次数
						  }).

%% 以下4个字段对应的格式为{module, function}
-record (gen_cache_call_back, {
	lookup,	
	%% lookup 定义为 module:function(IsFromDb::true|false, Mapper, Key, ExistRecordList) -> {true, NewRecordList} | false
	%% IsFromDb表示这次lookup是否是从db中读取数据的(根据这个看可以对数据进行初始化)
	%% Mapper是该gen_cache对应的mapper
	%% Key为你使用时传递给gen_cache:lookup/2的第二个参数
	%% ExistRecordList是已存在的记录数据，有可能为[]
	%% 返回false表明没有对ExistRecordList做任何修改，
	%% 返回{true, NewRecordList}表明进行了修改并且新的数据将插入到cache中，但不会更改数据库的

	update_element,
	
	update_record,
	%% update_record 定义为 module:function(OldRecordData, NewRecordData) -> {true, NewRecordData1} | false
	%% 返回false表明更新取消，其他表示执行更新NewRecordData1数据
	%% 注意OldRecordData有可能为[]

	insert
	}).
%% 更新索引的记录，key就是对于的记录数据的唯一key
-record(update_index, {key				
					   }).


%% gen_cache的选项
-record(gen_cache_opt, {
		update_interval = 5*60000,		%% 如果需要区别对待就在这里设置
		pre_load = false				%% 是否要预加载数据
	}).