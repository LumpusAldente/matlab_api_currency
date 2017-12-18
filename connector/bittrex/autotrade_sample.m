%-----------------------------------------------------
function response=POLO_Call(command,params)
% Donate BTC: 3NQ3RpAcXjNRgFXCAXuAf6icjuG31ZSfeT if like it
% appKey and appSecret-----------------------------
appKey='';
appSecret='';
%nonce
nonce=0.00001;%create a nonce of your style
%SHA512 encoding---------------------------------------------------------
addr='https://poloniex.com/tradingApi';
parameters=['command=',command,'&nonce=',nonce params];
requestString=HMAC(appSecret,parameters,'SHA-512');%hmac-shaxxx depends on exchange
%header=struct('name',name,'value',value);

header1=struct('name','Content-Type','value','application/x-www-form-urlencoded');
header2=struct('name','Key','value',appKey);
header3=struct('name','Sign','value',requestString);
headers=[header1, header2, header3];
response = urlread2(addr,'POST',parameters,headers);
%---------------------------------------------------------------------------
function response=POLO_ChkOdr

command='returnOpenOrders';
params='&currencyPair=all';
response=POLO_Call(command,params);
%-----------------------------------------------
function response=POLO_ClOdr(num)
%eg:POLO_ClOdr(7533967)
command='cancelOrder';
params=['&orderNumber=',num2str(num)];
response=POLO_Call(command,params);
%--------------------------------------------
function orderNumber=POLO_Trade(type,currencyPair,rate,amount)
%eg:POLO_Trade('buy','USDT_BTC',600,0.001)
command=type;
params=['&currencyPair=',currencyPair,'&rate=',num2str(rate),'&amount=',num2st
r(amount)];
response=POLO_Call(command,params) %let it disp to chk it
orderNumber=POLO_J2M(response,'orderNumber');
%-----------------------------------------------------------------------------------
function amt=POLO_Bal(currency)
%eg:POLO_Bal('BTC')
command='returnBalances';
params='';
tmp=POLO_Call(command,params);
amt=POLO_J2M(tmp,currency);
%------------------------------------------------------
function [sel,buy,avg]=POLO_Ticker(pair)

url=['https://poloniex.com/public?command=returnOrderBook&currencyPair=',pair];
tmp=urlread(url);
sel=POLO_J2M(tmp,'asks');
buy=POLO_J2M(tmp,'bids');
avg=mean([sel;buy]);
%----------------------------------------------------
function f=POLO_J2M(Str,GoStr)
%f=POLO_J2M(Str,'buy')
Str(Str=='{')=[]; Str(Str=='}')=[];
Str(Str=='[')=[]; Str(Str==']')=[];
Str(Str=='"')=[]; Str(Str==' ')=','; Str(Str==',')='`';
Str=['`',Str]; Str=[Str,'`'];
GoStr=['`',GoStr,':'];
%-----------------------------------

st=regexp(Str,GoStr); st=st+length(GoStr);
if  length(st)==1
    i=0; tmp=str2double(Str(st:(st+i)));
    while ~isnan(tmp) %if tmp is a number
          f=tmp; i=i+1;
          tmp=str2double(Str(st:(st+i)));
    end
    %------------------------------------
else
    error('[Chk the str you typed exists n is only one]')

end
%--------------------------------------------------------
%Note: if your matlab version is over 2016b, try jsondecode to replace POLO_J2M.m.
 %        if you wanna modify code for another exchange, 
 %        notice that you may needa check POLO_J2M.m works in exchange response format.
%
%now you can focus on your math analysis by matlab to trade,
%but remember that all is on your own risk.
%good luck!