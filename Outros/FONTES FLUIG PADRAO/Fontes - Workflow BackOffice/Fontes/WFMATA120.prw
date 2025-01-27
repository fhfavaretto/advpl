#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'WFMATA120.ch'

Static aWF1 	:= {}
Static aWF2 	:= {}
Static aWF3 	:= {}
Static aWF4 	:= {}
Static aWFC 	:= {}
Static aModelFlg:= {}
Static nLd	  	:= 1

//------------------------------------------------------------------
/*/{Protheus.doc} WFMATA120()
Workflow Pedido de Compras
@author rafael.duram
@since 27/08/15
@version 1.0
@return NIL
/*/ 
//-------------------------------------------------------------------

User Function WFMATA120()

Local oBrowse := NIL

oBrowse := FWMBrowse():New()
oBrowse:setAlias("SCR")
oBrowse:SetDescription(STR0001) // "Aprova��o Pedido de Compras"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
oBrowse:Activate()


Return NIL

//------------------------------------------------------------------
/*/{Protheus.doc} MenuDef()
Menu de op�oes do Browse
@author rafael.duram
@since 27/08/15
@version 1.0
@return aRotina
/*/
//-------------------------------------------------------------------

STATIC Function MenuDef()
Local aRotina	:= {}

ADD OPTION aRotina TITLE STR0002	ACTION 'VIEWDEF.WFMata120' OPERATION 2 ACCESS 0 // 'Visualizar'
ADD OPTION aRotina TITLE STR0003	ACTION 'VIEWDEF.WFMata120' OPERATION 3 ACCESS 0 // 'Incluir'
ADD OPTION aRotina TITLE STR0004	ACTION 'VIEWDEF.WFMata120' OPERATION 4 ACCESS 0 // 'Alterar'
ADD OPTION aRotina TITLE STR0005	ACTION 'VIEWDEF.WFMata120' OPERATION 5 ACCESS 0 // 'Excluir'
						
Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Defini��o do modelo de Dados

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel 	:= Nil
Local oStru1	:= FWFormModelStruct():New()
Local oStru2 	:= FWFormModelStruct():New()
Local oStru3 	:= FWFormModelStruct():New()
Local oStru4 	:= FWFormModelStruct():New()
Local aoStruC 	:= {}

//Local aModelFlg		:= {}	
Local lWFM120MODEL	:= .F.

Local nX			:= 0
Local nTamCC		:= 0
Local nTamCCont		:= 0
Local nTamIC		:= 0
Local nTamCV		:= 0
Local nTamFilial	:= 0
Local nTamFornec	:= 0

//- P.E que permite a inclus�o de novas estruturas ao modelo
If ExistBlock("WFM120MODEL")
	aWFC := ExecBlock("WFM120MODEL",.F.,.F.,{"STRUCT",aWFC,""})
	For nX:=1 To Len(aWFC)
		Aadd(aoStruC,FWFormModelStruct():New())
		aoStruC[nX]:AddTable("   ",{" "}," ")   
	Next nX
Endif

oStru1:AddTable("   ",{" "}," ")
oStru2:AddTable("   ",{" "}," ")
oStru3:AddTable("   ",{" "}," ")
oStru4:AddTable("   ",{" "}," ")

// -----------------------------------------------------------------------
// ESTRUTURA DO ARRAY
// --> [01] - campo, [02] - tipo, [03] - tamanho, [04] mascara, [05] - descri��o, [06] - titulo, [07] - combo, [08] - consulta padr�o, [09] - bWhen, [10] - bValid, [11] bInit
// -----------------------------------------------------------------------

// -----------------------------------------------------------------------
// GERA��O DA PRIMEIRA ESTRUTURA
// -----------------------------------------------------------------------
If Empty(aWF1)
	aAdd( aWF1,{'WF1_PAREC'	,'M' , 50 , '@!'	,STR0028	,STR0028	,{}	, NIL, Nil, Nil, Nil, 0   } ) // 'Parecer'
Endif
	
// -----------------------------------------------------------------------
// GERA��O DA SEGUNDA ESTRUTURA
// -----------------------------------------------------------------------
If Empty(aWF2)
	nTamFilial	:= TamSX3("C7_FILIAL")[1]+43 // XX8_DESCRI + 3 (" - ")
	nTamFornec	:= TamSX3("C7_FORNECE")[1]+TamSX3("C7_LOJA")[1]+TamSX3("A2_NOME")[1]+4
	aAdd( aWF2,{'WF2_FILIAL','C',nTamFilial				,'@!'							,STR0029	 ,STR0029	,{}	,NIL ,NIL, NIL ,NIL, 0   						} ) // 'Empresa'
	aAdd( aWF2,{'WF2_DOC'	,'C',TamSX3("C7_NUM")[1]	,'@!'							,STR0030	 ,STR0030	,{}	,NIL ,NIL, NIL ,NIL, 0   						} ) // 'Documento'
	aAdd( aWF2,{'WF2_EMIS'	,'D',8 						,''								,STR0031	 ,STR0031	,{}	,NIL ,NIL, NIL ,NIL, 0   						} ) // 'Emissao'
	aAdd( aWF2,{'WF2_COMPRA','C',40						,'@!'							,STR0032	 ,STR0032	,{}	,NIL ,NIL, NIL ,NIL, 0   						} ) // 'Comprador'
	aAdd( aWF2,{'WF2_FILENT','C',nTamFilial				,'@!'							,STR0033	 ,STR0033	,{}	,NIL ,NIL, NIL ,NIL, 0   						} ) // 'Entrega'
	aAdd( aWF2,{'WF2_FORNEC','C',nTamFornec				,'@!'							,STR0034	 ,STR0034	,{}	,NIL ,NIL, NIL ,NIL, 0  	 					} ) // 'Forn./Loja'
	aAdd( aWF2,{'WF2_MOEDA'	,'C',20						,'@!'							,STR0035	 ,STR0035 	,{}	,NIL ,NIL, NIL ,NIL, 0   						} ) // 'Moeda'
	aAdd( aWF2,{'WF2_VLTOT'	,'N',TamSX3("CR_TOTAL")[1]	,PesqPict("SCR","CR_TOTAL")		,STR0036	 ,STR0036	,{}	,NIL ,NIL, NIL ,NIL, TamSX3("CR_TOTAL")[2]   	} ) // 'Vl.Total'
Endif


// -----------------------------------------------------------------------
// GERA��O DA TERCEIRA ESTRUTURA
// -----------------------------------------------------------------------
If Empty(aWF3)
	nTamCC		:= TamSX3("CTT_CUSTO")[1]+TamSX3("CTT_DESC01")[1]+3
	nTamCCont	:= TamSX3("CT1_CONTA")[1]+TamSX3("CT1_DESC01")[1]+3
	nTamIC		:= TamSX3("CTD_ITEM")[1]+TamSX3("CTD_DESC01")[1]+3
	nTamCV		:= TamSX3("CTH_CLVL")[1]+TamSX3("CTH_DESC01")[1]+3
	aAdd( aWF3,{'WF3_TIPCOM','C',40							,'@!'							,STR0037	,STR0037	,{}  		,NIL ,NIL ,NIL ,NIL, 0   					} ) // 'Tp.Compra'
	aAdd( aWF3,{'WF3_PROD'	,'C',TamSX3("C7_PRODUTO")[1]	,'@!'							,STR0038	,STR0038	,{} 		,NIL ,NIL ,NIL ,NIL, 0   					} ) // 'Produto'
	aAdd( aWF3,{'WF3_DESPRD','C',TamSX3("C7_DESCRI")[1]		,'@!'							,STR0039	,STR0039	,{}  		,NIL ,NIL ,NIL ,NIL, 0   					} ) // 'Descricao'
	aAdd( aWF3,{'WF3_QUANT'	,'N',TamSX3("C7_QUANT")[1]		,PesqPict("SC7","C7_QUANT")		,STR0040	,STR0040	,{}  		,NIL ,NIL ,NIL ,NIL, TamSX3("C7_QUANT")[2]	} ) // 'Quantidade'
	aAdd( aWF3,{'WF3_VLUNIT','N',TamSX3("C7_PRECO")[1]		,PesqPict("SC7","C7_PRECO")		,STR0041	,STR0041	,{}  		,NIL ,NIL ,NIL ,NIL, TamSX3("C7_PRECO")[2]	} ) // 'Vl.Unit.'
	aAdd( aWF3,{'WF3_VLTOT'	,'N',TamSX3("C7_TOTAL")[1]		,PesqPict("SC7","C7_TOTAL")		,STR0042	,STR0042	,{}  		,NIL ,NIL ,NIL ,NIL, TamSX3("C7_TOTAL")[2]	} ) // 'Vl.Total'
	aAdd( aWF3,{'WF3_PERC'	,'N',TAMSX3("CH_PERC")[1]		,PesqPict("SCH","CH_PERC")		,STR0055	,STR0055	,{}			,NIL ,NIL, NIL ,NIL, TAMSX3("CH_PERC")[2]	} ) // '% Rateio'
	aAdd( aWF3,{'WF3_VLCALC','N',TAMSX3("C7_TOTAL")[1]		,PesqPict("SC7","C7_TOTAL")		,STR0056	,STR0056	,{}			,NIL ,NIL, NIL ,NIL, TAMSX3("C7_TOTAL")[2]	} ) // 'Vl.Rateado'
	aAdd( aWF3,{'WF3_CC'	,'C',nTamCC						,'@!'							,STR0043	,STR0043	,{}  		,NIL ,NIL ,NIL ,NIL, 0   					} ) // 'C. Custo'
	aAdd( aWF3,{'WF3_CCONT'	,'C',nTamCCont					,'@!'							,STR0044 	,STR0044	,{}  		,NIL ,NIL ,NIL ,NIL, 0   					} ) // 'C.Contabil'
	aAdd( aWF3,{'WF3_IC'	,'C',nTamIC						,'@!'							,STR0045	,STR0045	,{}  		,NIL ,NIL ,NIL ,NIL, 0   					} ) // 'It.Contab.'
	aAdd( aWF3,{'WF3_CV'	,'C',nTamCV						,'@!'							,STR0046	,STR0046	,{}  		,NIL ,NIL ,NIL ,NIL, 0   					} ) // 'C. Valor'
	aAdd( aWF3,{'WF3_DTENT'	,'D',8 							,''								,STR0047	,STR0047	,{}  		,NIL ,NIL ,NIL ,NIL, 0   					} ) // 'Dt.Entrega'
	aAdd( aWF3,{'WF3_OBSM'	,'M',50							,'@!'							,STR0048	,STR0048	,{}  		,NIL ,NIL ,NIL ,NIL, 0   					} ) // 'Observacao'
	aAdd( aWF3,{'WF3_NUMSC'	,'C',TamSX3("C7_NUMSC")[1]		,'@!'							,STR0049	,STR0049	,{}  		,NIL ,NIL ,NIL ,NIL, 0   					} ) // 'Num. SC'
	aAdd( aWF3,{'WF3_ITSC'	,'C',TamSX3("C7_ITEMSC")[1]		,'@!'							,STR0050	,STR0050	,{}  		,NIL ,NIL ,NIL ,NIL, 0   					} ) // 'Item SC'
Endif


//-- Inclus�o de estrutura aWF4 (Historico de aprovacao)
If Empty(aWF4)
	aAdd( aWF4, {'WF4_GRUPO'	,TAMSX3('AL_DESC')[3]		,TAMSX3('AL_DESC')[1]		,PesqPict('SAL','AL_DESC')		,'Grupo',		'Grupo',		{},	NIL,NIL,NIL,NIL,0	})	//Grupo
	aAdd( aWF4, {'WF4_NIVEL'	,TAMSX3('CR_NIVEL')[3]		,TAMSX3('CR_NIVEL')[1]		,PesqPict('SCR','CR_NIVEL')		,'Nivel',		'Nivel',		{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF4, {'WF4_USER'		,'C'						,200						,'@!'							,'Aprovador',	'Aprovador',	{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF4, {'WF4_STATUS'	,'C'						,50							,'@!'							,'Situa��o',	'Situa��o',		{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF4, {'WF4_DATA'		,TAMSX3('CR_DATALIB')[3]	,TAMSX3('CR_DATALIB')[1]	,PesqPict('SCR','CR_DATALIB')	,'Data',		'Data',			{},	NIL,NIL,NIL,NIL,0	})	//Nivel
	aAdd( aWF4, {'WF4_OBS'		,'M'						,254						,'@!'							,'Observa��es',	'Observa��es',	{},	NIL,NIL,NIL,NIL,0	})	//Nivel
EndIf


//------------------------------------------------------------------------
// Constru��o das estruturas
//------------------------------------------------------------------------

//- P.E que permite altera��o dos campos para customiza��o
If ExistBlock("WFM120MODEL") .And. !lWFM120MODEL
	aModelFlg 	:= {aWF1,aWF2,aWF3,aWF4}
	aModelFlg 	:= ExecBlock("WFM120MODEL",.F.,.F.,{"MODEL",aModelFlg,""})
	aWF1 		:= aModelFlg[1]
	aWF2 		:= aModelFlg[2]
	aWF3 		:= aModelFlg[3]
	aWF4 		:= aModelFlg[4]
	lWFM120MODEL:= .T. // Para que o PE rode somente uma vez	
EndIf

U_WF120Model(aWF1,"STRU1_",oStru1)
U_WF120Model(aWF2,"STRU2_",oStru2)
U_WF120Model(aWF3,"STRU3_",oStru3)
U_WF120Model(aWF4,"STRU4_",oStru4)

For nX:=1 To Len(aWFC) // Adiciona estruturas customizadas
	U_WF120Model(aModelFlg[nX+4],aWFC[nX,2],aoStruC[nX])
Next nX


// -----------------------------------------------------------------------
// Constru��o do modelo
// -----------------------------------------------------------------------
oModel := FWLoadModel("WFLIBDOC")

// -----------------------------------------------------------------------
// Adiciona ao modelo uma estrutura de formul�rio de edi��o por campo
// -----------------------------------------------------------------------
oModel:AddFields( 'WF1MASTER', 'SCRMASTER', oStru1, /*bPreValidacao*/, /*bPosValidacao*/, {|oModel| WF120LWF(oModel,"WF1") }/*bCarga*/ )
oModel:AddFields( 'WF2DETAIL', 'WF1MASTER', oStru2, /*bPreValidacao*/, /*bPosValidacao*/, {|oModel| WF120LWF(oModel,"WF2") }/*bCarga*/ )
oModel:AddGrid(   'WF3DETAIL', 'WF2DETAIL', oStru3, /* bLinePre*/ 	 , /* bLinePost */	, /* bPre*/							, /* bLinePost */ ,{|oModel|WF120LWF(oModel,"WF3")}/*bCarga*/  )
oModel:AddGrid(   'WF4DETAIL', 'SCRMASTER', oStru4, /* bLinePre*/ 	 , /* bLinePost */	, /* bPre*/							, /* bLinePost */ ,{|oModel|WF120LWF(oModel,"WF4")}/*bCarga*/  )

For nX:=1 To Len(aWFC) // Cria Grids e seta propriedades em estruturas customizadas
	oModel:AddGrid( aWFC[nX,3] , aWFC[nX,4], aoStruC[nX], /* bLinePre*/ 		, /* bLinePost */		, /* bPre*/	, /* bLinePost */ ,{|oModel|WF120LWF(oModel,aWFC[nLd,1])}/*bCarga*/  )
	oModel:GetModel(aWFC[nX,3]):SetDescription( aWFC[nX,5] )
	oModel:GetModel(aWFC[nX,3]):SetOnlyQuery(.T.)
	oModel:GetModel(aWFC[nX,3]):SetOptional(.T.)
	oModel:GetModel(aWFC[nX,3]):SetNoDeleteLine(.T.)
Next nX

// -----------------------------------------------------------------------
// Adiciona a descricao do Modelo de Dados
// -----------------------------------------------------------------------
oModel:SetDescription( 'Workflow de PC' )

// -----------------------------------------------------------------------
// Adiciona a descricao do Componente do Modelo de Dados
// -----------------------------------------------------------------------
oModel:GetModel( 'WF1MASTER' ):SetDescription( STR0052 ) // 'Decis�o'
oModel:GetModel( 'WF2DETAIL' ):SetDescription( STR0053 ) // 'Informa��es do Documento'
oModel:GetModel( 'WF3DETAIL' ):SetDescription( STR0054 ) // 'Itens'
oModel:GetModel( 'WF4DETAIL' ):SetDescription( STR0057 ) // 'Hist�rico Niv.Anterior'

oModel:GetModel("WF1MASTER"):SetOnlyQuery(.T.)
oModel:GetModel("WF2DETAIL"):SetOnlyQuery(.T.)
oModel:GetModel("WF3DETAIL"):SetOnlyQuery(.T.)
oModel:GetModel("WF4DETAIL"):SetOnlyQuery(.T.)

oModel:GetModel("WF3DETAIL"):SetOptional(.T.)
oModel:GetModel("WF4DETAIL"):SetOptional(.T.)

oModel:GetModel("WF3DETAIL"):SetNoDeleteLine(.T.)
oModel:GetModel("WF4DETAIL"):SetNoDeleteLine(.T.)

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} WF120Model
Fun��o para adicionar dinamicamente os campos na estrutura

@param aCampos Estrutura dos campos que ser�o adicionados
@param cStru Descri��o da estrutura onde os campos ser�o adicionados
@param oStru Objeto referente a estrutura

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

User Function WF120Model(aCampos,cStru,oStru)
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

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Defini��o do interface

@author jose.eulalio

@since 01/04/2014
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oModel	:= ModelDef()
Local oView		:= NIL
Local oStru1	:= FWFormViewStruct():New()
Local oStru2	:= FWFormViewStruct():New()
Local oStru3	:= FWFormViewStruct():New()
Local oStru4	:= FWFormViewStruct():New()
Local aoStruC	:= {} //Local oStru4	:= FWFormViewStruct():New()
Local nX		:= 0

U_WF120View(aWF1,'WF1_',oStru1)
U_WF120View(aWF2,'WF2_',oStru2)
U_WF120View(aWF3,'WF3_',oStru3)
U_WF120View(aWF4,'WF4_',oStru4)

For nX:=1 To Len(aWFC)
	Aadd(aoStruC,FWFormViewStruct():New())
	U_WF120View(aModelFlg[nX+4],aWFC[nX,6],aoStruC[nX])
Next nX

// -----------------------------------------------------------------------
// Monta o modelo da interface do formulario
// -----------------------------------------------------------------------
oView := FWLoadView("WFLIBDOC")

// -----------------------------------------------------------------------
// Define qual o Modelo de dados ser� utilizado
// -----------------------------------------------------------------------
oView:SetModel(oModel)

oView:AddField('VIEW_WF1', oStru1,'WF1MASTER')
oView:AddField('VIEW_WF2', oStru2,'WF2DETAIL')
oView:AddGrid( 'VIEW_WF3', oStru3,'WF3DETAIL')
oView:AddGrid( 'VIEW_WF4', oStru4,'WF4DETAIL')

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

// -----------------------------------------------------------------------
// Adiciona a descricao do Componente do Modelo de Dados
// -----------------------------------------------------------------------
oModel:GetModel( 'WF1MASTER' ):SetDescription( STR0052 ) // 'Decis�o'
oModel:GetModel( 'WF2DETAIL' ):SetDescription( STR0053 ) // 'Informa��es do Documento'
oModel:GetModel( 'WF3DETAIL' ):SetDescription( STR0054 ) // 'Itens'
oModel:GetModel( 'WF4DETAIL' ):SetDescription( STR0057 ) // 'Hist�rico Niv.Anterior'

oView:EnableTitleView('VIEW_WF1' , STR0052 ) // 'Decis�o'
oView:EnableTitleView('VIEW_WF2' , STR0053 ) // 'Informa��es do Documento'
oView:EnableTitleView('VIEW_WF3' , STR0054 ) // 'Itens'
oView:EnableTitleView('VIEW_WF4' , STR0057 ) // 'Hist�rico Niv.Anterior'

aWF1 		:= {}
aWF2 		:= {}
aWF3 		:= {}
aWF4 		:= {}
aModelFlg 	:= {}

Return oView 

//-------------------------------------------------------------------
/*/{Protheus.doc} WF120View
Fun��o para adicionar dinamicamente os campos na view

@param aCampos Estrutura dos campos que ser�o adicionados
@param cStru Descri��o da estrutura onde os campos ser�o adicionados
@param oStru Objeto referente a estrutura

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

User Function WF120View(aCampos,cStru,oStru)
Local nCampo 	:= 0
Local lAltCampo := .T.
Local aModelView:= {}

If ExistBlock("WFM120MODEL")
	aModelView := ExecBlock("WFM120MODEL",.F.,.F.,{"VIEW_HIDE",{},LEFT(cStru,3)})
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
					aCampos[nCampo][02]		,;	// [06]  C   Tipo do campo
					aCampos[nCampo][04]		,;	// [07]  C   Picture
					NIL							,;	// [08]  B   Bloco de Picture Var
					aCampos[nCampo][08]		,;	// [09]  C   Consulta F3
					lAltCampo					,;	// [10]  L   Indica se o campo � alteravel
					NIL							,;	// [11]  C   Pasta do campo
					NIL							,;	// [12]  C   Agrupamento do campo
					aCampos[nCampo][07]		,;	// [13]  A   Lista de valores permitido do campo (Combo)
					2							,;	// [14]  N   Tamanho maximo da maior op��o do combo
					NIL							,;	// [15]  C   Inicializador de Browse
					.F.							,;	// [16]  L   Indica se o campo � virtual
					NIL							,;	// [17]  C   Picture Variavel
					.F.							)	// [18]  L   Indica pulo de linha ap�s o campo
	Endif
		
Next nCampo

Return Nil

//--------------------------------------------------------------------
/*/{Protheus.doc} WF120LWF3(oModel)
Carrega os itens do pedido de compras para aprova��o
@author rafael.duram
@since 02/10/2015
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF120LWF3(oSC7Model)
Local cNum		:= ""	
Local cItem		:= ""
Local nI		:= 0
Local cNumSC7 	:= SC7->C7_NUM
Local aStruct	:= {"C7_TIPCOM","C7_PRODUTO","C7_DESCRI","C7_QUANT","C7_PRECO","C7_TOTAL","CH_PERC","C7_VLCALC","C7_CC","C7_CONTA","C7_ITEMCTA","C7_CLVL","C7_DATPRF","C7_OBSM","C7_NUMSC","C7_ITEMSC"}
Local aLoad    	:= {}
local aAux      := {}

//Query que retorna valores para Grid da SC7, levando em conta o Rateio e aprovadores
	
If Alltrim(SCR->CR_TIPO) == 'IP' // Aprova��o por Entidade Cont�bil (IP)
	
	BeginSQL Alias "LOADTMP"
	SELECT SC7.C7_NUM,
		SC7.C7_ITEM C7_ITEM,
		SC7.C7_TIPCOM C7_TIPCOM,
	    SC7.C7_PRODUTO C7_PRODUTO,
	    SC7.C7_DESCRI C7_DESCRI,
	    SC7.C7_QUANT 										  C7_QUANT,
	    SC7.C7_PRECO 										  C7_PRECO,
	    SC7.C7_TOTAL 										  C7_TOTAL,
	    SC7.C7_TOTAL / 100 * SCH.CH_PERC				  C7_VLCALC,
	    SCH.CH_PERC	 									  CH_PERC,   
	    ISNULL(SCH.CH_CC,SC7.C7_CC) C7_CC,
	    ISNULL(SCH.CH_CONTA,SC7.C7_CONTA) C7_CONTA,
	    ISNULL(SCH.CH_ITEMCTA,SC7.C7_ITEMCTA) C7_ITEMCTA,
	    ISNULL(SCH.CH_CLVL,SC7.C7_CLVL) C7_CLVL,	    
	    SC7.C7_DATPRF C7_DATPRF,
	    SC7.C7_NUMSC C7_NUMSC,
	    SC7.C7_ITEMSC C7_ITEMSC,
	    SC7.R_E_C_N_O_
	FROM %Table:DBM% DBM 
	JOIN %Table:SC7% SC7 ON 
	    SC7.%NotDel% AND
	    SC7.C7_FILIAL = %xFilial:SC7% AND
	    SC7.C7_NUM = DBM.DBM_NUM AND
	    SC7.C7_ITEM = DBM.DBM_ITEM
	LEFT JOIN %Table:SCH% SCH ON 
	    SCH.%NotDel% AND
	    SCH.CH_FILIAL = %xFilial:SCH% AND
	    SCH.CH_PEDIDO = SC7.C7_NUM AND
	    SCH.CH_ITEMPD = SC7.C7_ITEM AND
	    SCH.CH_ITEM = DBM.DBM_ITEMRA
	WHERE DBM.%NotDel% AND
	    DBM.DBM_FILIAL = %xFilial:DBM% AND
	    DBM.DBM_TIPO = %Exp:SCR->CR_TIPO% AND
	    DBM.DBM_NUM = %Exp:SCR->CR_NUM% AND
	    DBM.DBM_GRUPO = %Exp:SCR->CR_GRUPO% AND
	    DBM.DBM_ITGRP = %Exp:SCR->CR_ITGRP% AND
	    DBM.DBM_USER = %Exp:SCR->CR_USER% AND
		DBM.DBM_USAPRO = %Exp:SCR->CR_APROV% AND
	    DBM.DBM_USEROR = %Exp:SCR->CR_USERORI%
	ORDER BY SC7.C7_NUM,
		SC7.C7_ITEM
	EndSQL

Else

	BeginSQL Alias "LOADTMP"
	SELECT SC7.C7_NUM,
		SC7.C7_ITEM C7_ITEM,
		SC7.C7_TIPCOM C7_TIPCOM,
	    SC7.C7_PRODUTO C7_PRODUTO,
	    SC7.C7_DESCRI C7_DESCRI,
	    SC7.C7_QUANT C7_QUANT,
	    SC7.C7_PRECO C7_PRECO,
	    SC7.C7_TOTAL C7_TOTAL,
	    0 CH_PERC,
	    0 C7_VLCALC,	    
	    SC7.C7_CC C7_CC,
	    SC7.C7_CONTA C7_CONTA,
	    SC7.C7_ITEMCTA C7_ITEMCTA,
	    SC7.C7_CLVL C7_CLVL,	    
	    SC7.C7_DATPRF C7_DATPRF,
	    SC7.C7_NUMSC C7_NUMSC,
	    SC7.C7_ITEMSC C7_ITEMSC,
	    SC7.R_E_C_N_O_
	FROM %Table:SC7% SC7	    
	WHERE SC7.%NotDel% AND
		SC7.C7_FILIAL = %xFilial:SC7% AND
		SC7.C7_NUM = %Exp:cNumSC7%
	ORDER BY SC7.C7_NUM,
		SC7.C7_ITEM
	EndSQL

Endif

TCSetField("LOADTMP","C7_DATPRF","D",8,0)

//Popula modelo SC7DETAIL com os valores da query
While !LOADTMP->(EOF())
	aAux 	:= {}
	cNum	:= AllTrim(LOADTMP->C7_NUM)  
	cItem	:= AllTrim(LOADTMP->C7_ITEM)	
	
	SC7->(MsGoto(LOADTMP->R_E_C_N_O_))
	
	For nI := 1 To Len(aStruct)		
		If aStruct[nI] $ "C7_TIPCOM|C7_CC|C7_CONTA|C7_ITEMCTA|C7_CLVL"
			Aadd( aAux, Rtrim(LOADTMP->(&(aStruct[nI]))) + WF120Descr(aStruct[nI],LOADTMP->(&(aStruct[nI]))) )
		Elseif aStruct[nI] $ "C7_OBSM" // Campo memo real , pegar direto da tabela
			Aadd( aAux, SC7->C7_OBSM)		
		Else
			Aadd( aAux, LOADTMP->(&(aStruct[nI])))
		Endif
	Next nI
		
	aAdd(aLoad,{LOADTMP->R_E_C_N_O_,aClone(aAux)})												                                                                                                                																						
	
	LOADTMP->( DbSkip() )
End
   
LOADTMP->(dbCloseArea())

Return aLoad

//-------------------------------------------------------------------
/*/{Protheus.doc} WF120LWF1
Fun��o que retorna a carga de dados do cabe�alho da aprova��o da 
Solicita��o de Compras

@author Rafael Duram Santos
@since 01/10/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static function WF120LWF1(oModel)
Return {{""},0}

//-------------------------------------------------------------------
/*/{Protheus.doc} WF120LWF2
Fun��o que retorna a carga de dados do corpo da aprova��o da 
Solicita��o de Compras

@author Rafael Duram Santos
@since 01/10/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static function WF120LWF2(oModel)
Local aRet		:= {}
Local aAux		:= {}

//Posiciona pedido
dbSelectArea("SC7")
SC7->(dbSetOrder(1))
SC7->(dbSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,TamSX3("C7_NUM")[1])))

aAdd(aAux,SC7->C7_FILIAL+Iif(FWModeAccess("SC7")=="C",""," - "+FWFilialName(,SC7->C7_FILIAL)))
aAdd(aAux,SC7->C7_NUM)
aAdd(aAux,SC7->C7_EMISSAO)
aAdd(aAux,UsrFullName(SC7->C7_USER))
aAdd(aAux,SC7->C7_FILENT+" - "+FWFilialName(,SC7->C7_FILENT))
aAdd(aAux,SC7->C7_FORNECE+" "+SC7->C7_LOJA + WF120Descr("C7_FORNECE",SC7->(C7_FORNECE+C7_LOJA)))
aAdd(aAux,SuperGetMv("MV_MOEDA"+AllTrim(Str(SC7->C7_MOEDA,2))) )
aAdd(aAux,SCR->CR_TOTAL)

aRet := {aAux,0}

Return aRet

//-------------------------------------------------------------------
/*/{Protheus.doc} WF120Descr
Fun��o que retorna a descri��o dos campos de conta contabil 

@author Rafael Duram Santos
@since 07/10/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static function WF120Descr(cCampo,cChave)
Local aArea	:= GetArea()
Local cDescr:= ""

If !Empty(cChave)
	cDescr += " - "
	If cCampo == "C7_TIPCOM" //DHK
		cDescr += Substr(Posicione("DHK",1,xFilial("DHK")+cChave,"DHK_DESCR"),1,34)
	ElseIf cCampo == "C7_CC" //CTT
		cDescr += Posicione("CTT",1,xFilial("CTT")+cChave,"CTT_DESC01")
	Elseif cCampo == "C7_CONTA" //CT1
		cDescr += Posicione("CT1",1,xFilial("CT1")+cChave,"CT1_DESC01")
	Elseif cCampo == "C7_ITEMCTA" //CTD
		cDescr += Posicione("CTD",1,xFilial("CTD")+cChave,"CTD_DESC01")
	Elseif cCampo == "C7_CLVL" //CTH
		cDescr += Posicione("CTH",1,xFilial("CTH")+cChave,"CTH_DESC01")
	Elseif cCampo == "C7_FORNECE" //SA2
		cDescr += Posicione("SA2",1,xFilial("SA2")+cChave,"A2_NOME")	
	Endif
Endif

RestArea(aArea)

Return Rtrim(cDescr)

//-------------------------------------------------------------------
/*/{Protheus.doc} WF120LWF(oModel,cLoad)
Fun��o que retorna a carga de dados do cabe�alho da aprova��o

@author rafael.duram
@since 25/07/2016
@version 1.0
/*/
//-------------------------------------------------------------------
Static function WF120LWF(oModel,cLoad)
Local aReturn := {}

DO 	CASE	
	CASE cLoad == "WF1"
		aReturn := WF120LWF1(oModel)
	CASE cLoad == "WF2"
		aReturn := WF120LWF2(oModel)
	CASE cLoad == "WF3"
		aReturn := WF120LWF3(oModel)
	CASE cLoad == "WF4"
		aReturn := WF120LWF4(oModel)
	OTHERWISE
		If Len(aWFC) == nLd
			aWFC:= {}
		Else
			nLd++
		Endif				
ENDCASE

If ExistBlock("WFM120MODEL")
	aReturn := ExecBlock("WFM120MODEL",.F.,.F.,{"LOAD",aReturn,cLoad})	
EndIf


Return aReturn

//--------------------------------------------------------------------
/*/{Protheus.doc} GetTamTela(oModel)
Retorna a porcentagem da tela para cada modelo da estrutura
@author rafael.duram
@since 29/07/2016
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function GetTamTela(nPorc,nQtdMod)
Local aResult 	:= {}
Local nPorcPdr	:= 0
Local nX		:= 0

nPorcPdr := Round(nPorc/nQtdMod,0)
nSobra	  := (nPorcPdr*nQtdMod)-nPorc

Aadd(aResult,nPorcPdr-nSobra)

For nX:=2 To nQtdMod
	Aadd(aResult,nPorcPdr)
Next nX

Return aResult

//--------------------------------------------------------------------
/*/{Protheus.doc} WF120LWF4(oModel)
Carga da grid de aprova��o

@author rafael.duram
@since 19/08/2016
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF120LWF4(oModel)
Local aArea		:= GetArea()
Local aAreaSCR	:= SCR->(GetArea())
Local aAreaSAL	:= SAL->(GetArea())
Local aSaveLines:= FwSaveRows()
Local aLoad		:= {}
Local aAux		:= {}

Local cDoc 		:= SCR->CR_NUM
Local cTipo		:= SCR->CR_TIPO
Local cNivel 	:= SCR->CR_NIVEL //A097FstNiv(SCR->CR_GRUPO,cTipo,cDoc)
Local cTmpAlias	:= GetNextAlias()
Local cCond		:= ""
Local cAprIPPC	:= SuperGetMv("MV_APRIPPC",.F.,'2') // Aprova��o Item de Pedido em 2 etapas (IP+PC) 1-S 2-N

// Para que na aprova��o do Tipo PC seja mostrado hist�rico da aprova��o IP e primeiro nivel de IP seja inibido
If cTipo == 'PC' .And. cAprIPPC == '1'
	cCond := "% SCR.CR_TIPO = 'IP' OR SCR.CR_TIPO = 'PC' AND %"
Else
	cCond := "% SCR.CR_TIPO = '"+cTipo+"' AND %"
Endif


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
			(%Exp:cCond%
			SCR.CR_NIVEL  < %Exp:cNivel%)
			
	ORDER BY SCR.CR_TIPO, SCR.CR_NUM, SCR.CR_NIVEL
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
