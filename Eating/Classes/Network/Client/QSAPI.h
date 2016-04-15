//
//  QSAPI.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#ifndef eating_QSAPI_h
#define eating_QSAPI_h

static NSString *const QSAPIBaseUrlIP = @"http://117.41.235.110:800";
static NSString *const QSAPIBaseUrlDomain = @"http://api.77cdn.net";

//
//从appStore上获取最新的版本信息
//
static NSString *const QSGetAppStoreVersion = @"http://itunes.apple.com/lookup?id=908958155";

//
//打开应用下载地址
//
static NSString *const QSGotoAppStorePage = @"https://itunes.apple.com/cn/app/chi-ding-ni/id908958155?mt=8";

//
//获取token
//
static NSString *const QSGetToken = @"/total/getToken";

//
//Login
//
static NSString *const QSAPILogin = @"User/Login";

//
//Index
//
static NSString *const QSAPIIndexBanner = @"/merchant/AdList";

//
//Merchant
//
static NSString *const QSAPIMerchantList = @"/merchant/MerchantList";

static NSString *const QSAPIMerchantNearList = @"/merchant/GetNearMerchant";

static NSString *const QSAPIMerchantIndex = @"/merchant/GetModelIndex";

static NSString *const QSAPIMerchantAddError = @"/Help/AddMerError";

//
//Food
//
static NSString *const QSAPIFoodList = @"/goods/GoodsList";

static NSString *const QSAPIFoodDetail = @"/goods/MoGoodsDetail";

static NSString *const QSAPIFoodMenu = @"/user/GetMenu"; //搜索菜谱


//
//Comment
//
static NSString *const QSAPIMerchantCommentList = @"/comment/MerComList";

static NSString *const QSAPIMerchantMakeComment = @"/comment/AddCommon";
    
//
//Book
//
static NSString *const QSAPIMerchantBookAdd = @"/book/AddBookCli";

static NSString *const QSAPIBookOrderList = @"/book/UserBookList";

static NSString *const QSAPIBookOrderDetail = @"/book/GetBook";

static NSString *const QSAPIBookOrderDelay = @"book/addTimeOut";

//
//Takeout
//
static NSString *const QSAPITakeoutOrderList = @"/takeOut/UserTakeOutList";

static NSString *const QSAPITakeoutOrderDetail = @"/takeOut/GetTakeOut";

static NSString *const QSAPITakeoutOrderAdd = @"/takeOut/AddTakeOutCli";

static NSString *const QSAPITakeoutPayOrder = @"/takeOut/PayOrder";

static NSString *const QSAPITakeoutPayCommit = @"/takeOut/PayCommit";

//
//User
//
static NSString *const QSAPIUserRegister = @"/user/phoneRegist";

static NSString *const QSAPIUserUpdate = @"/user/UpdateMsg";

static NSString *const QSAPIUserUpdatePassword = @"/user/ChangePSW";

static NSString *const QSAPIUserChangePasswordByPhone = @"/user/ChangePSWByPhone";

static NSString *const QSAPIUserBindPhone = @"/user/BingPhone";

static NSString *const QSAPIUserBindEmail = @"/user/ChangeEmail";

static NSString *const QSAPIVerCode = @"/merchant/getVerCode";

static NSString *const QSAPIRandomTagList = @"/user/GetTagList";

static NSString *const QSAPIUserTagList = @"/user/ListUserTag";

static NSString *const QSAPIUserChnageLogo = @"/user/ChangeLogo";

static NSString *const QSAPIUpdateTag = @"/user/updateTag";

static NSString *const QSAPIAddTag = @"/user/AddTag";

static NSString *const QSAPIDelTag = @"/user/DelTag";

static NSString *const QSAPIUserLikeMer = @"/user/UserLikeMer"; //关注商家--收藏商家

static NSString *const QSAPUserLikeGreens = @"/user/UserLikeGreens"; //关注菜品--收藏菜品

static NSString *const QSAPIUserStoreGreens = @"/user/UserStoreGreens"; //用户自己收藏的菜品列表

static NSString *const QSAPIUserStoreMer = @"/user/UserStoreMer"; //用户收藏的商家列表

static NSString *const QSAPIUserUnLikeMer = @"/user/UserUnLikeMer"; //用户取消关注商家--用户取消收藏商家

static NSString *const QSAPIUserUnLikeGreens = @"/user/UserUnLikeGreens"; //用户取消关注菜品--用户取消收藏菜品

static NSString *const QSAPIIsMerStore = @"/user/IsMerStore"; //是否收藏商家

static NSString *const QSAPIIsGoodStore = @"/user/IsGoodStore"; //是否收藏用户

static NSString *const QSAPIUserGood = @"/user/good"; //点赞

static NSString *const QSAPIUserUnGood = @"/user/unGood"; //取消点赞

//
//Delivery
//
static NSString *const QSAPIDeliveryList = @"/user/ListAddress";

static NSString *const QSAPIDeliveryUpdate = @"/user/UpAddress";

static NSString *const QSAPIDeliveryAdd = @"/user/AddAddress";

static NSString *const QSAPIDeliveryDelete = @"/user/DelAddress";

//
//Coupon
//
static NSString *const QSAPIUserCouponList = @"/Coup/UserCoupList";

static NSString *const QSAPIRecommendCouponList = @"/promotions/getMerAllPro";

//
//Trade
//
static NSString *const QSAPIBillList = @"/bill/list";

//
//Message
//
static NSString *const QSAPIUserTalkList = @"/message/TalkList";

static NSString *const QSAPIMerchantChatList = @"/message/UserAndMerTalkList";

static NSString *const QSAPIMerchantChatAdd = @"/message/AddNewTalk";


//
//FoodGroud
//
static NSString *const QSAPIFoodGroud = @"/Coup/UserCoupList";

//
//FoodDetectiveRecommend
//
static NSString *const QSAPIFoodDetectiveRecommend = @"/activity/AcList";

//
//FoodDetectiveMarAcNotice
//
static NSString *const QSAPIFoodDetectiveMarAcNotice = @"/activity/MarAcNotice";

//
//try activities
//
static NSString *const QSAPITryActivityDetail = @"/activity/ActivityDetail";

//
//article detail
//
static NSString *const QSAPIArticleDetail = @"/activity/GetActivityDetail";

//
//article detail
//
static NSString *const QSAPIForAGroup = @"/Discovery/AddDiscovery";

//
//article detail
//
static NSString *const QSAPIJoinActivity = @"/activity/JoinAc";

//
//article detail
//
static NSString *const QSAPIPayPrivateKey = @"site/privateKey";

//
//coupon list
//
static NSString *const QSAPIMarchantCouponList = @"/promotions/list";

//
//个人的优惠券列表
//
static NSString *const QSAPIMyMarchantCouponList = @"/promotions/userList";

//
//coupon detail
//
static NSString *const QSAPIMarchantCouponDetail = @"/goods/get";

//
//储值卡退款接口
//
static NSString *const QSAPIPrepaidCardRefund = @"storeCard/Back";

//
//新订单请求
//
static NSString *const QSAPIAlixPayOrderSign = @"/Indent/add";

//
//老订单支付
//
static NSString *const QSAPIAlixPayOldOrderSign = @"/Indent/PayAgain";

//
//支付的结果回调服务端
//
static NSString *const QSAPIAlixPayRebackServer = @"/Indent/payCommitIndent";

//
//领取优惠券
//
static NSString *const QSAPIGetCoupon = @"/coup/UserGet";

//
//获取搭食团列表
//
static NSString *const QSAPIFoodGroudList = @"/TeamActivity/TeamListSup";

//
//获取个人优惠券列表
//
static NSString *const QSAPIMyCouponBoxList = @"/storeCard/list";

//
//新增一个搭食团
//
static NSString *const QSAPIAddFoodGroud = @"/TeamActivity/AddTeamAc";

//
//获取个人搭食团列表
//
static NSString *const QSAPIMyFoodGroudList = @"/TeamActivity/UserTeamList";

//
//报名参与搭食团
//
static NSString *const QSAPIJoinFoodGroud = @"/TeamActivity/JoinTeam";

//
//退出已参与的搭食团
//
static NSString *const QSAPIOutFoodGroud = @"/TeamActivity/OutTeam";

//
//团长点击成团
//
static NSString *const QSAPICommitFoodGroud = @"/TeamActivity/CommitTeamAc";

//
//搭食团聊天信息：获取聊天消息列表
//
static NSString *const QSAPIFoodGroudTalkList = @"/TeamActivity/ChatList";

//
//搭食团聊天信息：发送消息
//
static NSString *const QSAPIFoodGroudAddMessage = @"/TeamActivity/AddChat";

//
//发送短信
//
static NSString *const QSAPISendPhoneMessage = @"/message/AddSendMsg";

//
//搭食团详情信息
//
static NSString *const QSAPIFoodGroudDetail = @"/TeamActivity/GetActivityMsg";

#endif
