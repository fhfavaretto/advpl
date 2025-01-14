#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'WFMATA110.ch'

Static aWF1 	:= {}
Static aWF2 	:= {}
Static aWF3 	:= {}
Static aWF4 	:= {}
Static aWFC 	:= {}
Static aModelFlg:= {}
Static nLd	  	:= 1

/*/{Protheus.doc} WFMATA110()
Cadastro de Edital
@author jose.eulalio
@since 02/04/13
@version 1.0
@return NIL
/*/ 

User Function WFMATA110()
Local oBrowse := nil

oBrowse := FWMBrowse():New()
oBrowse:setAlias("SCR")
oBrowse:SetDescription(STR0001) // "Aprova��o Solicita��o de Compras"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
oBrowse:Activate()

Return NIL

/*/{Protheus.doc} MenuDef()
Menu de op��es do Browse
@author jose.eulalio
@since 02/04/13
@version 1.0
@return aRotina
/*/

STATIC Function MenuDef()
Local aRotina	:= {}

ADD OPTION aRotina TITLE STR0002	ACTION 'VIEWDEF.WFMata110' OPERATION 2 ACCESS 0 // 'Visualizar'
ADD OPTION aRotina TITLE STR0003	ACTION 'VIEWDEF.WFMata110' OPERATION 3 ACCESS 0 // 'Incluir'
ADD OPTION aRotina TITLE STR0004	ACTION 'VIEWDEF.WFMata110' OPERATION 4 ACCESS 0 // 'Alterar'
ADD OPTION aRotina TITLE STR0005	ACTION 'VIEWDEF.WFMata110' OPERATION 5 ACCESS 0 // 'Excluir'
						
Return aRotina

/*/{Protheus.doc} ModelDef
Defini��o do modelo de Dados

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/

Static Function ModelDef()
Local oModel 	:= Nil
Local oStru1 	:= FWFormModelStruct():New()
Local oStru2 	:= FWFormModelStruct():New()
Local oStru3 	:= FWFormModelStruct():New()
Local oStru4 	:= FWFormModelStruct():New()
Local aoStruC 	:= {}

Local lWFM110MODEL	:= .F.

Local nX			:= 0
Local nTamCC		:= 0
Local nTamCCont		:= 0
Local nTamIC		:= 0
Local nTamCV		:= 0
Local nTamFilial	:= 0

//- P.E que permite a inclus�o de novas estruturas ao modelo
If ExistBlock("WFM110MODEL")
	aWFC := ExecBlock("WFM110MODEL",.F.,.F.,{"STRUCT",aWFC,""})
	For nX:=1 To Len(aWFC)
		Aadd(aoStruC,FWFormModelStruct():New())
		aoStruC[nX]:AddTable("   ",{" "}," ")   
	Next nX
Endif

oStru1:AddTable("   ",{" "}," ")
oStru2:AddTable("   ",{" "}," ")
oStru3:AddTable("   ",{" "}," ")
oStru4:AddTable("   ",{" "}," ")

// ESTRUTURA DO ARRAY
// --> [01] - campo, [02] - tipo, [03] - tamanho, [04] mascara, [05] - descri��o, [06] - titulo, [07] - combo, [08] - consulta padr�o, [09] - bWhen, [10] - bValid, [11] bInit

// GERA��O DA PRIMEIRA ESTRUTURA
If Empty(aWF1)
	aAdd( aWF1,{'WF1_PAREC'	,'M' , 50 , '@!'	,STR0014	,STR0014	,{}		, NIL, Nil, Nil, Nil, 0   } ) // 'Parecer'
EndIf

// GERA��O DA SEGUNDA ESTRUTURA
If Empty(aWF2)
	nTamFilial := TamSX3("C1_FILIAL")[1]+43 // XX8_DESCRI + 3 (" - ")
	aAdd( aWF2,{'WF2_FILIAL'	,'C',nTamFilial					,'@!'							,STR0015	,STR0015	,{}	,NIL ,NIL, NIL ,NIL, 0   					} ) // 'Filial'
	aAdd( aWF2,{'WF2_DOC'		,'C',TAMSX3("C1_NUM")[1]		,'@!'							,STR0016	,STR0016	,{}	,NIL ,NIL, NIL ,NIL, 0   					} ) // 'Documento'
	aAdd( aWF2,{'WF2_EMIS'		,'D',TAMSX3("C1_EMISSAO")[1]	,''								,STR0017	,STR0017	,{}	,NIL ,NIL, NIL ,NIL, 0  	 				} ) // 'Emissao'
	aAdd( aWF2,{'WF2_SOLIC'		,'C',40							,'@!'							,STR0012	,STR0012	,{}	,NIL ,NIL, NIL ,NIL, 0   					} ) // 'Solicitante'
	aAdd( aWF2,{'WF2_FILENT'	,'C',nTamFilial					,'@!'							,STR0018	,STR0018  	,{}	,NIL ,NIL, NIL ,NIL, 0   					} ) // 'Entrega'
	aAdd( aWF2,{'WF2_MOEDA'		,'C',20							,''								,STR0019 	,STR0019  	,{}	,NIL ,NIL, NIL ,NIL, 0   					} ) // 'Moeda'
	aAdd( aWF2,{'WF2_VLTOT'		,'N',TAMSX3("CR_TOTAL")[1]		,PesqPict("SCR","CR_TOTAL")		,STR0020	,STR0020	,{}	,NIL ,NIL, NIL ,NIL, TAMSX3("CR_TOTAL")[2]	} ) // 'Vl.Total'
Endif

// GERA��O DA TERCEIRA ESTRUTURA
If Empty(aWF3)
	nTamCC		:= TamSX3("CTT_CUSTO")[1]+TamSX3("CTT_DESC01")[1]+3
	nTamCCont	:= TamSX3("CT1_CONTA")[1]+TamSX3("CT1_DESC01")[1]+3
	nTamIC		:= TamSX3("CTD_ITEM")[1]+TamSX3("CTD_DESC01")[1]+3
	nTamCV		:= TamSX3("CTH_CLVL")[1]+TamSX3("CTH_DESC01")[1]+3
	aAdd( aWF3,{'WF3_TIPCOM','C',40						,'@!'							,STR0021	,STR0021	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} )//	'Tipo Compra'
	aAdd( aWF3,{'WF3_PROD'	,'C',TAMSX3("C1_PRODUTO")[1],'@!'							,STR0022	,STR0022	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} )//	'Produto'
	aAdd( aWF3,{'WF3_DESPRD','C',TAMSX3("C1_DESCRI")[1]	,'@!'							,STR0023	,STR0023	,{}	,NIL ,NIL ,NIL ,NIL, 0  	 					} )//	'Descricao'
	aAdd( aWF3,{'WF3_QUANT'	,'N',TAMSX3("C1_QUANT")[1]	,PesqPict("SC1","C1_QUANT")		,STR0024	,STR0024	,{}	,NIL ,NIL ,NIL ,NIL, TAMSX3("C1_QUANT")[2]   	} )//	'Quantidade'
	aAdd( aWF3,{'WF3_VLUNIT','N',TAMSX3("C1_VUNIT")[1]	,PesqPict("SC1","C1_VUNIT")		,STR0025	,STR0025	,{}	,NIL ,NIL ,NIL ,NIL, TAMSX3("C1_VUNIT")[2]   	} )//	'Vl.Unit.'
	aAdd( aWF3,{'WF3_VLTOT'	,'N',TAMSX3("CR_TOTAL")[1]	,PesqPict("SCR","CR_TOTAL")		,STR0026	,STR0026	,{}	,NIL ,NIL ,NIL ,NIL, TAMSX3("CR_TOTAL")[2]   	} )//	'Vl.Total'
	aAdd( aWF3,{'WF3_PERC'	,'N',TAMSX3("CX_PERC")[1]	,PesqPict("SCX","CX_PERC")		,STR0037	,STR0037	,{}	,NIL ,NIL, NIL ,NIL, TAMSX3("CX_PERC")[2]		} )//  '% Rateio'
	aAdd( aWF3,{'WF3_VLCALC','N',TAMSX3("CR_TOTAL")[1]	,PesqPict("SCR","CR_TOTAL")		,STR0038	,STR0038	,{}	,NIL ,NIL, NIL ,NIL, TAMSX3("CR_TOTAL")[2]		} )//  'Vl.Rateado'
	aAdd( aWF3,{'WF3_CC'	,'C',nTamCC					,'@!'							,STR0027	,STR0027	,{}	,NIL ,NIL ,NIL ,NIL, 0  						} )//	'C. Custo'
	aAdd( aWF3,{'WF3_CCONT'	,'C',nTamCCont				,'@!'							,STR0028	,STR0028	,{}	,NIL ,NIL ,NIL ,NIL, 0  						} )//	'C.Contabil'
	aAdd( aWF3,{'WF3_IC'	,'C',nTamIC					,'@!'							,STR0029	,STR0029	,{}	,NIL ,NIL ,NIL ,NIL, 0  						} )//	'It.Contab.'
	aAdd( aWF3,{'WF3_CV'	,'C',nTamCV					,'@!'							,STR0030	,STR0030	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} )//	'C. Valor'
	aAdd( aWF3,{'WF3_DTNES'	,'D',8 						,''								,STR0031	,STR0031	,{}	,NIL ,NIL ,NIL ,NIL, 0   						} )//	'Dt.Neces'
	aAdd( aWF3,{'WF3_OBS'	,'C',TAMSX3("C1_OBS")[1]	,'@!'							,STR0032	,STR0032	,{}	,NIL ,NIL ,NIL ,NIL, 0  						} )//	'Observacao'
Endif

//-- Inclus�o de estrutura aWF4 (Historico de aprovacao)
If Empty(aWF4)
	aAdd( aWF4, {'WF4_GRUPO'	,TAMSX3('AL_DESC')[3]		,TAMSX3('AL_DESC')[1]		,PesqPict('SAL','AL_DESC')		,'Grupo',		'Grupo',		{},	NIL,NIL,NIL,NIL,0	})	//Grupo
	aAdd( aWF4, {'WF4_NIVEL'	,TAMSX3('CR_NIVEL')[3]		,TAMSX3('CR_NIVEL')[1]		,PesqPict('SCR','CR_NIVEL')		,'Nivel',		'Nivel',		{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF4, {'WF4_USER'		,'C'						,200						,'@!'							,'Aprovador',	'Aprovador',	{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF4, {'WF4_STATUS'	,'C'						,50							,'@!'							,'Situa��o',	'Situa��o',		{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF4, {'WF4_DATA'		,TAMSX3('CR_DATALIB')[3]	,TAMSX3('CR_DATALIB')[1]	,PesqPict('SCR','CR_DATALIB')	,'Data',		'Data',			{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF4, {'WF4_OBS'		,'M'						,254						,'@!'							,'Observa��es','Observa��es',	{},	NIL,NIL,NIL,NIL,0	})	//Nivel
EndIf

// Constru��o das estruturas
//- P.E que permite altera��o dos campos para customiza��o
If ExistBlock("WFM110MODEL") .And. !lWFM110MODEL
	aModelFlg := {aWF1,aWF2,aWF3,aWF4}
	aModelFlg := ExecBlock("WFM110MODEL",.F.,.F.,{"MODEL",aModelFlg,""})
	aWF1 := aModelFlg[1]
	aWF2 := aModelFlg[2]
	aWF3 := aModelFlg[3]
	aWF4 := aModelFlg[4]
	lWFM110MODEL := .T. // Para que o PE rode somente uma vez	
EndIf

WF110Model(aWF1,"STRU1_",oStru1)
WF110Model(aWF2,"STRU2_",oStru2)
WF110Model(aWF3,"STRU3_",oStru3)
WF110Model(aWF4,"STRU4_",oStru4)

For nX:=1 To Len(aWFC) // Adiciona estruturas customizadas
	WF110Model(aModelFlg[nX+4],aWFC[nX,2],aoStruC[nX])
Next nX

// Constru��o do modelo
oModel := FWLoadModel("WFLIBDOC")

// Adiciona ao modelo uma estrutura de formul�rio de edi��o por campo
oModel:AddFields( 'WF1MASTER', 'SCRMASTER', oStru1, /*bPreValidacao*/	, /*bPosValidacao*/	, {|oModel|WF110LWF(oModel,"WF1")} )
oModel:AddFields( 'WF2DETAIL', 'WF1MASTER', oStru2, /*bPreValidacao*/	, /*bPosValidacao*/	, {|oModel|WF110LWF(oModel,"WF2")} )
oModel:AddGrid(   'WF3DETAIL', 'WF2DETAIL', oStru3, /* bLinePre*/ 		, /* bLinePost */	, /* bPre*/							, /* bLinePost */ ,{|oModel|WF110LWF(oModel,"WF3")} /*bCarga*/ 	)
oModel:AddGrid(   'WF4DETAIL', 'SCRMASTER', oStru4, /* bLinePre*/ 		, /* bLinePost */	, /* bPre*/							, /* bLinePost */ ,{|oModel|WF110LWF(oModel,"WF4")} /*bCarga*/ 	)

For nX:=1 To Len(aWFC) // Cria Grids e seta propriedades em estruturas customizadas
	oModel:AddGrid( aWFC[nX,3] , aWFC[nX,4], aoStruC[nX], /* bLinePre*/ 		, /* bLinePost */		, /* bPre*/	, /* bLinePost */ ,{|oModel|WF110LWF(oModel,aWFC[nLd,1])}/*bCarga*/  )
	oModel:GetModel(aWFC[nX,3]):SetDescription( aWFC[nX,5] )
	oModel:GetModel(aWFC[nX,3]):SetOnlyQuery(.T.)
	oModel:GetModel(aWFC[nX,3]):SetOptional(.T.)
	oModel:GetModel(aWFC[nX,3]):SetNoDeleteLine(.T.)
Next nX

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription('Workflow de SC' )

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'WF1MASTER' ):SetDescription( STR0034 ) // 'Decis�o'
oModel:GetModel( 'WF2DETAIL' ):SetDescription( STR0035 ) // 'Informa��es do Documento'
oModel:GetModel( 'WF3DETAIL' ):SetDescription( STR0036 ) // 'Itens'
oModel:GetModel( 'WF4DETAIL' ):SetDescription( STR0039 ) // 'Hist�rico Niv.Anterior'

oModel:GetModel("WF1MASTER"):SetOnlyQuery(.T.)
oModel:GetModel("WF2DETAIL"):SetOnlyQuery(.T.)
oModel:GetModel("WF3DETAIL"):SetOnlyQuery(.T.)
oModel:GetModel("WF4DETAIL"):SetOnlyQuery(.T.)

oModel:GetModel("WF3DETAIL"):SetOptional(.T.)
oModel:GetModel("WF4DETAIL"):SetOptional(.T.)

oModel:GetModel("WF3DETAIL"):SetNoDeleteLine(.T.)
oModel:GetModel("WF4DETAIL"):SetNoDeleteLine(.T.)

Return oModel

/*/{Protheus.doc} WF110Model
Fun��o para adicionar dinamicamente os campos na estrutura

@param aCampos Estrutura dos campos que ser�o adicionados
@param cStru Descri��o da estrutura onde os campos ser�o adicionados
@param oStru Objeto referente a estrutura

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/

Static Function WF110Model(aCampos,cStru,oStru)
Local nCampo := 1

For nCampo := 1 To Len(aCampos)
	//cCampo := cStru + aCampos[nCampo][01]
	//-- Adiciona campos header do filtro de busca de fornecedor
	
	oStru:AddField(aCampos[nCampo][05]		,;	// 	[01]  C   Titulo do campo
				 	aCampos[nCampo][06]		,;	// 	[02]  C   ToolTip do campo
				 	aCampos[nCampo][01]		,;	// 	[03]  C   Id do Field
				 	aCampos[nCampo][02]		,;	// 	[04]  C   Tipo do campo
				 	aCampos[nCampo][03]		,;	// 	[05]  N   Tamanho do campo
				 	aCampos[nCampo][12]		,;	// 	[06]  N   Decimal do campo
				 	aCampos[nCampo][10]		,;	// 	[07]  B   Code-block de valida��o do campo
				 	aCampos[nCampo][09]		,;	// 	[08]  B   Code-block de valida��o When do campo
				 	aCampos[nCampo][07]		,;	//	[09]  A   Lista de valores permitido do campo
				 	.F.						,;	//	[10]  L   Indica se o campo tem preenchimento obrigat�rio
				 	aCampos[nCampo][11]		,;	//	[11]  B   Code-block de inicializacao do campo
				 	NIL						,;	//	[12]  L   Indica se trata-se de um campo chave
				 	.F.						,;	//	[13]  L   Indica se o campo pode receber valor em uma opera��o de update.
				 	.F.						)	// 	[14]  L   Indica se o campo � virtual
Next nCampo

Return Nil

/*/{Protheus.doc} ViewDef
Defini��o do interface

@author jose.eulalio

@since 01/04/2014
@version 1.0
/*/

Static Function ViewDef()
Local oModel	:= ModelDef()
Local oView		:= NIL
Local oStru1	:= FWFormViewStruct():New()
Local oStru2	:= FWFormViewStruct():New()
Local oStru3	:= FWFormViewStruct():New()
Local oStru4	:= FWFormViewStruct():New()
Local aoStruC	:= {}
Local nX		:= 0

WF110View(aWF1,'WF1_',oStru1)
WF110View(aWF2,'WF2_',oStru2)
WF110View(aWF3,'WF3_',oStru3)
WF110View(aWF4,'WF4_',oStru4)

For nX:=1 To Len(aWFC)
	Aadd(aoStruC,FWFormViewStruct():New())
	WF110View(aModelFlg[nX+4],aWFC[nX,6],aoStruC[nX])
Next nX

// Monta o modelo da interface do formulario
oView := FWLoadView("WFLIBDOC")

// Define qual o Modelo de dados ser� utilizado
oView:SetModel(oModel)

oView:AddField('VIEW_WF1', oStru1	,'WF1MASTER')
oView:AddField('VIEW_WF2', oStru2	,'WF2DETAIL')
oView:AddGrid( 'VIEW_WF3', oStru3	,'WF3DETAIL')
oView:AddGrid( 'VIEW_WF4', oStru4	,'WF4DETAIL')

For nX:=1 To Len(aWFC)
	oView:AddGrid( aWFC[nX,7], aoStruC[nX],aWFC[nX,3])	
Next nX

If Len(aModelFlg) > 0
	aTela := GetTamTela(99,Len(aModelFlg))
Else
	aTela := {24,25,25,25}
Endif

oView:CreateHorizontalBox( 'WF1' ,aTela[1] )
oView:CreateHorizontalBox( 'WF2' ,aTela[2] )
oView:CreateHorizontalBox( 'WF3' ,aTela[3] )
oView:CreateHorizontalBox( 'WF4' ,aTela[4] )

For nX:=1 To Len(aWFC)
	oView:CreateHorizontalBox( aWFC[nX,1] , aTela[nX+3] )
	oView:SetOwnerView(aWFC[nX,7],aWFC[nX,1])
	oModel:GetModel( aWFC[nX,3] ):SetDescription( aWFC[nX,5] )
	oView:EnableTitleView(aWFC[nX,7] , aWFC[nX,5] )
Next nX

oView:SetOwnerView('VIEW_WF1','WF1')
oView:SetOwnerView('VIEW_WF2','WF2')
oView:SetOwnerView('VIEW_WF3','WF3')
oView:SetOwnerView('VIEW_WF4','WF4')

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'WF1MASTER' ):SetDescription( STR0034 ) // 'Decis�o'
oModel:GetModel( 'WF2DETAIL' ):SetDescription( STR0035 ) // 'Informa��es do Documento'
oModel:GetModel( 'WF3DETAIL' ):SetDescription( STR0036 ) // 'Itens'
oModel:GetModel( 'WF4DETAIL' ):SetDescription( STR0039 ) // 'Hist�rico Niv.Anterior'

oView:EnableTitleView('VIEW_WF1' , STR0034 ) // 'Decis�o'
oView:EnableTitleView('VIEW_WF2' , STR0035 ) // 'Informa��es do Documento'
oView:EnableTitleView('VIEW_WF3' , STR0036 ) // 'Itens'
oView:EnableTitleView('VIEW_WF4' , STR0039 ) // 'Hist�rico Niv.Anterior'

aWF1 := {}
aWF2 := {}
aWF3 := {}
aWF4 := {}
aModelFlg := {}

Return oView 

/*/{Protheus.doc} WF110View
Fun��o para adicionar dinamicamente os campos na view

@param aCampos Estrutura dos campos que ser�o adicionados
@param cStru Descri��o da estrutura onde os campos ser�o adicionados
@param oStru Objeto referente a estrutura

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/

Static Function WF110View(aCampos,cStru,oStru)
Local nCampo 		:= 0
Local lAltCampo 	:= .T.
Local aModelView	:= {}

If ExistBlock("WFM110MODEL")
	aModelView := ExecBlock("WFM110MODEL",.F.,.F.,{"VIEW_HIDE",{},LEFT(cStru,3)})
EndIf

For nCampo := 1 To Len(aCampos)
	//--> [01] - campo, [02] - tipo, [03] - tamanho, [04] mascara, [05] - descri��o, [06] - titulo, [07] - combo, [08] - consulta padr�o, [09] - bWhen, [10] - bValid, [11] bInit
	lAltCampo := Iif(aCampos[nCampo,1] $ 'WF1_PAREC|WF1_SITUAC',.T.,.F.)
	cOrdem := StrZero(nCampo,2)
		
	If !aScan(aModelView,aCampos[nCampo][01])	
		//-- Adiciona campos header do filtro de busca de fornecedor 
		oStru:AddField(aCampos[nCampo][01]		,;	// [01]  C   Nome do Campo
					cOrdem						,;	// [02]  C   Ordem
					aCampos[nCampo][05] 		,;	// [03]  C   Titulo do campo
					aCampos[nCampo][06] 		,;	// [04]  C   Descricao do campo
					{}							,;	// [05]  A   Array com Help
					aCampos[nCampo][02]			,;	// [06]  C   Tipo do campo
					aCampos[nCampo][04]			,;	// [07]  C   Picture
					NIL							,;	// [08]  B   Bloco de Picture Var
					aCampos[nCampo][08]			,;	// [09]  C   Consulta F3
					lAltCampo							,;	// [10]  L   Indica se o campo � alteravel
					NIL							,;	// [11]  C   Pasta do campo
					NIL							,;	// [12]  C   Agrupamento do campo
					aCampos[nCampo][07]			,;	// [13]  A   Lista de valores permitido do campo (Combo)
					2							,;	// [14]  N   Tamanho maximo da maior op��o do combo
					NIL							,;	// [15]  C   Inicializador de Browse
					.F.							,;	// [16]  L   Indica se o campo � virtual
					NIL							,;	// [17]  C   Picture Variavel
					.F.							)	// [18]  L   Indica pulo de linha ap�s o campo
	Endif
Next nCampo

Return Nil

/*/{Protheus.doc} WF110LWF3(oSC1Model)
Carrega os itens da solicita��o de compras para aprova��o
@author Rafael Duram
@since 01/10/2015
@version 1.0
@return aLoad
/*/

Static Function WF110LWF3(oSC1Model)
Local cNum		:= ""	
Local cItem		:= ""	
Local nI		:= 0
Local cNumSC1	:= SC1->C1_NUM
Local aStruct	:= {"C1_TIPCOM","C1_PRODUTO","C1_DESCRI","C1_QUANT","C1_VUNIT","TOTAL","CX_PERC","C1_VLCALC","C1_CC","C1_CONTA","C1_ITEMCTA","C1_CLVL","C1_DATPRF","C1_OBS"}
Local cAprovSC	:= SuperGetMv("MV_APROVSC",.F.,"0") 
Local lAlcSolCtb:= SuperGetMv("MV_APRSCEC",.F.,.F.) .Or. (ValType(cAprovSC)=="C" .And. cAprovSC=="3")
Local aLoad		:= {}
local aAux		:= {}
Local n110TotPrd:= 0
Local nValUnit	:= 0

//Query que retorna valores para Grid da SC1, levando em conta o Rateio e aprovadores

If lAlcSolCtb

	BeginSQL Alias "LOADTMP"
	SELECT SC1.C1_NUM,
		SC1.C1_ITEM C1_ITEM,
		SC1.C1_TIPCOM C1_TIPCOM,
	    SC1.C1_PRODUTO C1_PRODUTO,
	    SC1.C1_DESCRI C1_DESCRI,
	    SC1.C1_QUANT  			C1_QUANT,
	    SC1.C1_VUNIT  			C1_VUNIT,
	    SCX.CX_PERC	 			CX_PERC,
	    ISNULL(SCX.CX_CC,SC1.C1_CC) C1_CC,
	    ISNULL(SCX.CX_CONTA,SC1.C1_CONTA) C1_CONTA,
	    ISNULL(SCX.CX_ITEMCTA,SC1.C1_ITEMCTA) C1_ITEMCTA,
	    ISNULL(SCX.CX_CLVL,SC1.C1_CLVL) C1_CLVL,
	    SC1.C1_DATPRF C1_DATPRF,
		SC1.C1_OBS C1_OBS,
	    SC1.R_E_C_N_O_
	    
	FROM %Table:DBM% DBM 
	JOIN %Table:SC1% SC1 ON 
	    SC1.%NotDel% AND
	    SC1.C1_FILIAL = %xFilial:SC1% AND
	    SC1.C1_NUM = DBM.DBM_NUM AND
	    SC1.C1_ITEM = DBM.DBM_ITEM
	LEFT JOIN %Table:SCX% SCX ON 
	    SCX.%NotDel% AND
	    SCX.CX_FILIAL = %xFilial:SCX% AND
	    SCX.CX_SOLICIT = SC1.C1_NUM AND
	    SCX.CX_ITEMSOL = SC1.C1_ITEM AND
	    SCX.CX_ITEM = DBM.DBM_ITEMRA
	WHERE DBM.%NotDel% AND
	    DBM.DBM_FILIAL = %xFilial:DBM% AND
	    DBM.DBM_TIPO = %Exp:SCR->CR_TIPO% AND
	    DBM.DBM_NUM = %Exp:SCR->CR_NUM% AND
	    DBM.DBM_GRUPO = %Exp:SCR->CR_GRUPO% AND
	    DBM.DBM_ITGRP = %Exp:SCR->CR_ITGRP% AND
	    DBM.DBM_USER = %Exp:SCR->CR_USER% AND
	    DBM.DBM_USEROR = %Exp:SCR->CR_USERORI%
	ORDER BY SC1.C1_NUM,
		SC1.C1_ITEM
	EndSQL

Else

	BeginSQL Alias "LOADTMP"
	SELECT SC1.C1_NUM,
		SC1.C1_ITEM C1_ITEM,
	    SC1.C1_TIPCOM C1_TIPCOM,
	    SC1.C1_PRODUTO C1_PRODUTO,
	    SC1.C1_DESCRI C1_DESCRI,
	    SC1.C1_QUANT C1_QUANT,
	    SC1.C1_VUNIT C1_VUNIT,
	    0 CX_PERC,
	    SC1.C1_CC C1_CC,
	    SC1.C1_CONTA C1_CONTA,
	    SC1.C1_ITEMCTA C1_ITEMCTA,
	    SC1.C1_CLVL C1_CLVL,
	    SC1.C1_DATPRF C1_DATPRF,
		SC1.C1_OBS C1_OBS,
	    SC1.R_E_C_N_O_
	    
	FROM %Table:SC1% SC1	    
	WHERE SC1.%NotDel% AND
		SC1.C1_FILIAL = %xFilial:SC1% AND
		SC1.C1_NUM = %Exp:cNumSC1%
	ORDER BY SC1.C1_NUM,
		SC1.C1_ITEM 
	EndSQL

Endif

TCSetField("LOADTMP","C1_DATPRF","D",8,0)

//Popula modelo SC1DETAIL com os valores da query
While !LOADTMP->(EOF())
	aAux := {}
	cNum	:= AllTrim(LOADTMP->C1_NUM)  
	cItem	:= AllTrim(LOADTMP->C1_ITEM)	
	
	If SC1->(dbSeek(xFilial("SC1")+ cNum + cItem ) )
		For nI := 1 To Len(aStruct)
			If aStruct[nI] $ "C1_TIPCOM|C1_CC|C1_CONTA|C1_ITEMCTA|C1_CLVL"
				Aadd( aAux, Rtrim(LOADTMP->(&(aStruct[nI]))) + WF110Descr(aStruct[nI],LOADTMP->(&(aStruct[nI]))) )
			Elseif aStruct[nI] == "C1_VUNIT"
				If LOADTMP->(&(aStruct[nI])) = 0
					nValUnit := MTGetVProd(LOADTMP->(&("C1_PRODUTO")))
				Else
					nValUnit := LOADTMP->(&(aStruct[nI]))
				Endif
				Aadd( aAux, nValUnit )
			Elseif aStruct[nI] == "TOTAL"
				n110TotPrd := LOADTMP->(&("C1_QUANT")) * nValUnit
				Aadd( aAux, n110TotPrd)
			Elseif aStruct[nI] == "C1_VLCALC"
				If lAlcSolCtb
					n110TotPrd := LOADTMP->(&("C1_QUANT")) * nValUnit / 100 * LOADTMP->(&("CX_PERC"))
					Aadd( aAux, n110TotPrd)
				Else
					Aadd( aAux, 0 )
				Endif
			Else 		
				Aadd( aAux, LOADTMP->(&(aStruct[nI])))
			Endif
		Next nI
		
		aAdd(aLoad,{LOADTMP->R_E_C_N_O_,aClone(aAux)})												                                                                                                                																						
	EndIf
	LOADTMP->( DbSkip() )
End
   
LOADTMP->(dbCloseArea())

Return aLoad

/*/{Protheus.doc} WF110LWF1
Fun��o que retorna a carga de dados do cabe�alho da aprova��o da 
Solicita��o de Compras

@author Rafael Duram Santos
@since 30/09/2015
@version 1.0
/*/

Static function WF110LWF1(oModel)
Local aRet		:= {}
Local aAux		:= {}

aAdd(aAux,"")		// Parecer 

aRet := {aAux,0}

Return aRet

/*/{Protheus.doc} WF110LWF2
Fun��o que retorna a carga de dados do corpo da aprova��o da 
Solicita��o de Compras

@author Rafael Duram Santos
@since 30/09/2015
@version 1.0
/*/

Static function WF110LWF2(oModel)
Local aRet		:= {}
Local aAux		:= {}
Local cUsrName	:= ""

//Posiciona solicita��o
dbSelectArea("SC1")
SC1->(dbSetOrder(1))
SC1->(dbSeek(xFilial("SC1")+Substr(SCR->CR_NUM,1,TamSX3("C1_NUM")[1])))

If !Empty(SC1->C1_SOLICIT)
	cUsrName := SC1->C1_SOLICIT
Else
	cUsrName := UsrFullName(SC1->C1_USER)
Endif

aAdd(aAux,SC1->C1_FILIAL+Iif(FWModeAccess("SC1")=="C",""," - "+FWFilialName(,SC1->C1_FILIAL)))
aAdd(aAux,SC1->C1_NUM)
aAdd(aAux,SC1->C1_EMISSAO)
aAdd(aAux,cUsrName)
aAdd(aAux,SC1->C1_FILENT+" - "+FWFilialName(,SC1->C1_FILENT))
aAdd(aAux,SuperGetMv("MV_MOEDA"+AllTrim(Str(Iif(SC1->C1_MOEDA=0,1,SC1->C1_MOEDA),2))) )
aAdd(aAux,SCR->CR_TOTAL)

aRet := {aAux,0}

Return aRet

/*/{Protheus.doc} WF110Descr
Fun��o que retorna a descri��o dos campos de conta contabil 

@author Rafael Duram Santos
@since 06/10/2015
@version 1.0
/*/

Static function WF110Descr(cCampo,cChave)
Local aArea	:= GetArea()
Local cDescr	:= ""

If !Empty(cChave)
	cDescr += " - "
	If cCampo == "C1_TIPCOM" //DHK
		cDescr += Substr(Posicione("DHK",1,xFilial("DHK")+cChave,"DHK_DESCR"),1,34)
	ElseIf cCampo == "C1_CC" //CTT
		cDescr += Posicione("CTT",1,xFilial("CTT")+cChave,"CTT_DESC01")
	Elseif cCampo == "C1_CONTA" //CT1
		cDescr += Posicione("CT1",1,xFilial("CT1")+cChave,"CT1_DESC01")
	Elseif cCampo == "C1_ITEMCTA" //CTD
		cDescr += Posicione("CTD",1,xFilial("CTD")+cChave,"CTD_DESC01")
	Elseif cCampo == "C1_CLVL" //CTH
		cDescr += Posicione("CTH",1,xFilial("CTH")+cChave,"CTH_DESC01")
	Endif
Endif

RestArea(aArea)

Return Rtrim(cDescr)

/*/{Protheus.doc} WF110LWF(oModel,cLoad)
Fun��o que retorna a carga de dados do cabe�alho da aprova��o

@author rafael.duram
@since 03/08/2016
@version 1.0
/*/

Static function WF110LWF(oModel,cLoad)
Local aReturn := {}

DO 	CASE
	CASE cLoad == "WF1"
		aReturn := WF110LWF1(oModel)
	CASE cLoad == "WF2"
		aReturn := WF110LWF2(oModel)
	CASE cLoad == "WF3"
		aReturn := WF110LWF3(oModel)
	CASE cLoad == "WF4"
		aReturn := WF110LWF4(oModel)
	OTHERWISE		
		If Len(aWFC) == nLd
			aWFC:= {}
		Else
			nLd++
		Endif				
ENDCASE

If ExistBlock("WFM110MODEL")
	aReturn := ExecBlock("WFM110MODEL",.F.,.F.,{"LOAD",aReturn,cLoad})
EndIf

Return aReturn

/*/{Protheus.doc} GetTamTela(oModel)
Retorna a porcentagem da tela para cada modelo da estrutura
@author rafael.duram
@since 29/07/2016
@version 1.0
@return aLoad
/*/

Static Function GetTamTela(nPorc,nQtdMod)
Local aResult := {}
Local nPorcPdr:= 0
Local nX	  := 0

nPorcPdr := Round(nPorc/nQtdMod,0)
nSobra	 := (nPorcPdr*nQtdMod)-nPorc

Aadd(aResult,nPorcPdr-nSobra)

For nX:=2 To nQtdMod
	Aadd(aResult,nPorcPdr)
Next nX

Return aResult

/*/{Protheus.doc} WF110LWF4(oModel)
Carga da grid de aprova��o

@author rafael.duram
@since 19/08/2016
@version 1.0
@return aLoad
/*/

Static Function WF110LWF4(oModel)
Local aArea		:= GetArea()
Local aAreaSCR	:= SCR->(GetArea())
Local aAreaSAL	:= SAL->(GetArea())
Local aSaveLines:= FwSaveRows()
Local aLoad		:= {}
Local aAux		:= {}

Local cDoc 		:= SCR->CR_NUM
Local cTipo		:= SCR->CR_TIPO
Local cNivel 	:= SCR->CR_NIVEL
Local cTmpAlias	:= GetNextAlias()

//Query que retorna as aprova��es referentes aos n�veis anteriores ao atual
BeginSQL Alias cTmpAlias
	SELECT	SCR.CR_NUM			CR_NUM,
			SCR.CR_NIVEL		CR_NIVEL,
			SCR.CR_USER			CR_USER,
			SCR.CR_DATALIB		CR_DATALIB,
	   		SCR.CR_STATUS		CR_STATUS,
	   		SCR.CR_GRUPO		CR_GRUPO,
			SCR.CR_OBS			CR_OBS,
	   		SCR.R_E_C_N_O_
	   		

	FROM 	%Table:SCR% SCR

	WHERE	SCR.%NotDel% AND
			SCR.CR_FILIAL = %xFilial:SCR% AND
			SCR.CR_NUM 	  = %Exp:cDoc% AND
			SCR.CR_TIPO	  = %Exp:cTipo% AND
			SCR.CR_NIVEL  < %Exp:cNivel%

	ORDER BY SCR.CR_NUM, SCR.CR_NIVEL
EndSQL

TCSetField(cTmpAlias,"CR_DATALIB","D",8,0)

While !(cTmpAlias)->(EOF())
	aAux := {}
	aAdd(aAux,AllTrim(Posicione("SAL",1,xFilial("SAL")+(cTmpAlias)->CR_GRUPO,"AL_DESC"))) 	// WF4_GRUPO
	aAdd(aAux,(cTmpAlias)->CR_NIVEL)																// WF4_NIVEL
	aAdd(aAux,AllTrim(UsrFullName((cTmpAlias)->CR_USER))) 										// WF4_USER
	aAdd(aAux,AllTrim(x3CboxToArray("CR_STATUS")[1][Val((cTmpAlias)->CR_STATUS)])) 			// WF4_STATUS
	aAdd(aAux,(cTmpAlias)->CR_DATALIB)																// WF4_DATA

	//- Posiciona na tabela fisica para obter valor do Memo Observa��o
	SCR->(MsGoto((cTmpAlias)->R_E_C_N_O_))
	aAdd(aAux,AllTrim(SCR->CR_OBS))																	// WF4_OBS

	aAdd(aLoad, {(cTmpAlias)->R_E_C_N_O_,aClone(aAux)})
	(cTmpAlias)->(DbSkip())
End

(cTmpAlias)->(dbClosearea())
FWRestRows(aSaveLines)
RestArea(aAreaSAL)
RestArea(aAreaSCR)
RestArea(aArea)

Return aLoad
