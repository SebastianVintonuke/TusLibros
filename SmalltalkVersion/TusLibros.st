!classDefinition: #CajeroTest category: #TusLibros!
TestCase subclass: #CajeroTest
	instanceVariableNames: 'unCarrito'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CajeroTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:26:14'!
assertAlCarritoHacer: unClosureQueModificaElCarrito
cajeroConMerchantProcessor: unMerchantProcessor
hacerCheckoutConTarjeta: unaTarjetaDeCredito
validarQue: unClosureAValidar
	| unCajero unRecibo |
	
	unClosureQueModificaElCarrito value.

	unCajero := Cajero newConMerchantProcessor: unMerchantProcessor.
	unRecibo := unCajero checkOutDelCarrito: unCarrito
							delCatalogo:  self catalogoConExtremeProgramming
							conTarjeta: unaTarjetaDeCredito.
	
	unClosureAValidar value: unRecibo! !

!CajeroTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:26:14'!
assertAlCarritoHacer: unClosureQueModificaElCarrito
cajeroConMerchantProcessor: unMerchantProcessor
hacerCheckoutConTarjeta: unaTarjetaDeCredito
validarQueLanzaElError: unErrorAValidar
	| unCajero |
	
	unClosureQueModificaElCarrito value.

	unCajero := Cajero newConMerchantProcessor: unMerchantProcessor.
	
	self should: [
			unCajero checkOutDelCarrito: unCarrito
					  delCatalogo:  self catalogoConExtremeProgramming
					  conTarjeta: unaTarjetaDeCredito
		]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: unErrorAValidar equals: anError messageText.
		]
! !

!CajeroTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 20:28:05'!
setUp

	unCarrito := Carrito new! !

!CajeroTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:44:53'!
test01unCajeroNoPuedeHacerCheckOutDeUnCarritoVacio

	self assertAlCarritoHacer: []
		  cajeroConMerchantProcessor: self stubMerchantProcessorQueCobra
		  hacerCheckoutConTarjeta: self fakeTarjetaDeCreditoValida
		  validarQueLanzaElError: Cajero errorNoSePuedeHacerCheckOutDeUnCarritoVacio
! !

!CajeroTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 21:31:42'!
test02unCajeroPuedeHacerCheckOutDeUnCarritoConUnLibroYDevuelveUnReciboQueSabeElMonto 

	self assertAlCarritoHacer: [
			unCarrito añadir: self libroExtremeProgramming
				       delCatalogo: self catalogoConExtremeProgramming
		]
		cajeroConMerchantProcessor: self stubMerchantProcessorQueCobra
		hacerCheckoutConTarjeta: self fakeTarjetaDeCreditoValida
		validarQue: [ :recibo |
			self deny: (recibo tienePrecioTotal: 0).
			self assert: (recibo tienePrecioTotal: 1).
			self deny: (recibo tienePrecioTotal: 2)
		]! !

!CajeroTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 21:32:04'!
test03unCajeroPuedeHacerCheckOutDeUnCarritoConMasDeUnLibroYDevuelveUnReciboQueSabeElMonto 

	self assertAlCarritoHacer: [
			unCarrito añadir: self libroExtremeProgramming
                     delCatalogo: self catalogoConExtremeProgramming.	
			unCarrito añadir: self libroExtremeProgramming
                     delCatalogo: self catalogoConExtremeProgramming
		]
		cajeroConMerchantProcessor: self stubMerchantProcessorQueCobra
		hacerCheckoutConTarjeta: self fakeTarjetaDeCreditoValida
		validarQue: [ :recibo |
			self deny: (recibo tienePrecioTotal: 1).
			self assert: (recibo tienePrecioTotal: 2).
			self deny: (recibo tienePrecioTotal: 3)
		]

! !

!CajeroTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:44:06'!
test04unCajeroNoPuedeHacerCheckOutDeUnCarritoConUnaTarjetaVencida

	self assertAlCarritoHacer: [
			unCarrito añadir: self libroExtremeProgramming
					   delCatalogo: self catalogoConExtremeProgramming
		]
		cajeroConMerchantProcessor: self stubMerchantProcessorQueCobra
		hacerCheckoutConTarjeta: self fakeTarjetaDeCreditoVencida
		validarQueLanzaElError: Cajero errorTarjetaDeCreditoVencida
! !

!CajeroTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:44:04'!
test05unCajeroNoPuedeHacerCheckOutSiSuMerchantProcessorFalla

	self assertAlCarritoHacer: [
			unCarrito añadir: self libroExtremeProgramming
					   delCatalogo: self catalogoConExtremeProgramming
		]
		cajeroConMerchantProcessor: self stubMerchantProcessorQueFalla
		hacerCheckoutConTarjeta: self fakeTarjetaDeCreditoValida
		validarQueLanzaElError: Cajero errorNoSePudoRealizarElCobro
! !

!CajeroTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:44:11'!
test06unCajeroVaciaElCarritoLuegoDelCheckOut

	self assertAlCarritoHacer: [
			unCarrito añadir: self libroExtremeProgramming
				       delCatalogo: self catalogoConExtremeProgramming.	
		]
		cajeroConMerchantProcessor: self stubMerchantProcessorQueCobra
		hacerCheckoutConTarjeta: self fakeTarjetaDeCreditoValida
		validarQue: [ :unRecibo |
			self assert: unCarrito estaVacio
		]! !


!CajeroTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:27:53'!
catalogoConExtremeProgramming
	| catalogo |

	catalogo := Dictionary new.
	catalogo at: self libroExtremeProgramming put: 1.

	^ catalogo
! !

!CajeroTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:27:57'!
fakeTarjetaDeCreditoValida

	^ TarjetaDeCredito newConNumeroDeTarjeta: 1 conMesDeAñoDeExpiracion: (GregorianMonthOfYear current) conTitular: ''.
! !

!CajeroTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:28:00'!
fakeTarjetaDeCreditoVencida
	| unaFechaDeVencimiento |

	unaFechaDeVencimiento := GregorianMonthOfYear decemberOf: (GregorianYear number: 2000).	

	^ TarjetaDeCredito newConNumeroDeTarjeta: 1 conMesDeAñoDeExpiracion: unaFechaDeVencimiento conTitular: ''
! !

!CajeroTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:28:02'!
libroExtremeProgramming

	^ #ExtremeProgramming
! !

!CajeroTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:28:07'!
stubMerchantProcessorQueCobra

	^ [ :monto :tarjeta | ]! !

!CajeroTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:28:11'!
stubMerchantProcessorQueFalla

	^ [ :monto :tarjeta | self error: 'Merchant Processor Error' ]! !


!classDefinition: #CarritoTest category: #TusLibros!
TestCase subclass: #CarritoTest
	instanceVariableNames: 'unCarrito'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CarritoTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 20:28:52'!
setUp

	unCarrito := Carrito new! !

!CarritoTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 21:27:07'!
test01unCarritoEmpiezaVacio	

	self assert: unCarrito estaVacio.
	self deny: (unCarrito incluye: self libroExtremeProgramming).! !

!CarritoTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:38:51'!
test02unCarritoPuedeAgregarUnLibro

	unCarrito añadir: self libroExtremeProgramming
			   delCatalogo: self catalogoConExtremeProgramming.
	
	self deny: unCarrito estaVacio.
	self assert: (unCarrito incluye: self libroExtremeProgramming)! !

!CarritoTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:42:41'!
test03unCarritoPuedeAgregarOtroLibro

	unCarrito añadir: self libroExtremeProgramming
			   delCatalogo: self catalogoConExtremeProgrammingYTestDriveDevelopment.
	unCarrito añadir: self libroTestDriveDevelopment
			   delCatalogo: self catalogoConExtremeProgrammingYTestDriveDevelopment.

	self assert: (unCarrito incluye: self libroExtremeProgramming).
	self assert: (unCarrito incluye: self libroTestDriveDevelopment)! !

!CarritoTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:39:35'!
test04unCarritoNoPuedeNoAgregarLibrosDescatalogados

	self should: [
			unCarrito añadir: self libroExtremeProgramming
					   delCatalogo: self catalogoVacio
		]
		 raise: Error 
		 withExceptionDo: [ :anError |
			self assert: Carrito errorNoSePuedeAñadirLibroDescatalogado equals: anError messageText
		]! !

!CarritoTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:40:02'!
test05listarUnCarritoVacioDevuelveUnaColeccionVacia

	self assert: unCarrito listar isEmpty
	! !

!CarritoTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:40:05'!
test06listarUnCarritoConUnLibroDevuelveUnaColleccionConElLibro

	unCarrito añadir: self libroExtremeProgramming
			   delCatalogo: self catalogoConExtremeProgramming.

	self assert: (unCarrito listar includes: self libroExtremeProgramming)
	! !

!CarritoTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:40:21'!
test07unCarritoPuedeAgregarMultiplesCopiasDeUnMismoLibro

	unCarrito añadir: self libroExtremeProgramming
			   cantidadDeCopias: 2
			   delCatalogo: self catalogoConExtremeProgramming.
	
	self assert: (unCarrito listar occurrencesOf: self libroExtremeProgramming) equals: 2! !

!CarritoTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 20:29:00'!
test08unCarritoNoPuedeAgregarCeroCopiasDeUnMismoLibro

	self should: [
			unCarrito añadir: self libroExtremeProgramming
					   cantidadDeCopias: 0
					   delCatalogo: self catalogoConExtremeProgramming
		]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Carrito errorNoSePuedeAgregarMenosDeUnaCopiaDeUnLibro equals: anError messageText
		]
! !

!CarritoTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:41:28'!
test09unCarritoNoPuedeAgregarCopiasNegativasDeUnMismoLibro

	self should: [
			unCarrito añadir: self libroExtremeProgramming
					   cantidadDeCopias: -1
					   delCatalogo: self catalogoConExtremeProgramming
		]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Carrito errorNoSePuedeAgregarMenosDeUnaCopiaDeUnLibro equals: anError messageText.
		]
! !

!CarritoTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:41:41'!
test10unCarritoSePuedeVaciar

	unCarrito añadir: self libroExtremeProgramming
			   delCatalogo: self catalogoConExtremeProgramming.

	self deny: unCarrito estaVacio.
	
	unCarrito vaciar.
	
	self assert: unCarrito estaVacio.
	! !


!CarritoTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:28:34'!
catalogoConExtremeProgramming
	| catalogo |

	catalogo := Dictionary new.
	catalogo at: self libroExtremeProgramming put: 1.

	^ catalogo! !

!CarritoTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:28:37'!
catalogoConExtremeProgrammingYTestDriveDevelopment
	| catalogo |

	catalogo := self catalogoConExtremeProgramming.
	catalogo at: self libroTestDriveDevelopment put: 1.

	^ catalogo! !

!CarritoTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:28:42'!
catalogoVacio
	| catalogo |

	catalogo := Dictionary new.

	^ catalogo! !

!CarritoTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:28:45'!
libroExtremeProgramming

	^ #ExtremeProgramming! !

!CarritoTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:28:47'!
libroTestDriveDevelopment

	^ #TestDriveDevelopment! !


!classDefinition: #InterfazExternaTest category: #TusLibros!
TestCase subclass: #InterfazExternaTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InterfazExternaTest methodsFor: 'utilidades' stamp: 'S.V. 6/22/2024 20:31:11'!
catalogoConExtremeProgramming
	| catalogo |

	catalogo := Dictionary new.
	catalogo at: self iSBNLibroExtremeProgramming put: 1.

	^ catalogo! !

!InterfazExternaTest methodsFor: 'utilidades' stamp: 'S.V. 6/22/2024 20:31:15'!
catalogoVacio
	| catalogo |

	catalogo := Dictionary new.

	^ catalogo! !

!InterfazExternaTest methodsFor: 'utilidades' stamp: 'S.V. 6/22/2024 20:31:22'!
iSBNLibroExtremeProgramming

	^ '9780201710915'! !

!InterfazExternaTest methodsFor: 'utilidades' stamp: 'S.V. 6/22/2024 19:25:15'!
mesDeAñoDeExpiracionValido
	| current year month |
	
	current := GregorianMonthOfYear current.
	month := current month number.
	year := current year number.

	(month < 10) ifTrue: [
		^ '0', month asString, year asString
	] ifFalse: [
		^ month asString, year asString
	]

	! !

!InterfazExternaTest methodsFor: 'utilidades' stamp: 'S.V. 6/22/2024 20:31:48'!
stubAutenticadorQueAutenticaTodo

	^ [ :usuario :contraseña | ]! !

!InterfazExternaTest methodsFor: 'utilidades' stamp: 'S.V. 6/22/2024 20:31:51'!
stubAutenticadorQueNoAutenticaNada

	^ [ :usuario :contraseña | self error: 'Invalid credentials' ]! !

!InterfazExternaTest methodsFor: 'utilidades' stamp: 'S.V. 6/22/2024 20:31:53'!
stubMerchantProcessorQueCobraTodo

	^ [ :monto :tarjeta | ]! !


!InterfazExternaTest methodsFor: 'interfacesInternas' stamp: 'S.V. 6/23/2024 17:24:47'!
interfazExternaConInterfazInternaConCatalogoVacio
	| interfazInterna |

	interfazInterna := InterfazInterna newConSesionQueNoExpiraCatalogo: self catalogoVacio
											sistemaDeAutenticacion: self stubAutenticadorQueAutenticaTodo 
											merchantProcessor: self stubMerchantProcessorQueCobraTodo.
									
	^ InterfazExterna newCon: interfazInterna! !

!InterfazExternaTest methodsFor: 'interfacesInternas' stamp: 'S.V. 6/23/2024 17:24:54'!
interfazExternaConInterfazInternaQueHaceTodo
	| interfazInterna |

	interfazInterna := InterfazInterna newConSesionQueNoExpiraCatalogo: self catalogoConExtremeProgramming
											sistemaDeAutenticacion: self stubAutenticadorQueAutenticaTodo 
											merchantProcessor: self stubMerchantProcessorQueCobraTodo.
									
	^ InterfazExterna newCon: interfazInterna! !

!InterfazExternaTest methodsFor: 'interfacesInternas' stamp: 'S.V. 6/23/2024 17:24:59'!
interfazExternaConInterfazInternaQueNoAutenticaNada
	| interfazInterna |

	interfazInterna := InterfazInterna newConSesionQueNoExpiraCatalogo: self catalogoConExtremeProgramming
											sistemaDeAutenticacion: self stubAutenticadorQueNoAutenticaNada
											merchantProcessor: self stubMerchantProcessorQueCobraTodo.
									
	^ InterfazExterna newCon: interfazInterna! !


!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 18:29:04'!
test01unaInterfazExternaRespondeExitosamenteAlCrearCarrito
	| unaInterfazExterna respuestaCrear |

	unaInterfazExterna := self interfazExternaConInterfazInternaQueHaceTodo.

	respuestaCrear := self interfazInterna: unaInterfazExterna
							  crearCarritoConCliente: ''
							  yContraseña: ''.

	self assertQueUnaRespuestaDeCrearUnCarritoEsValida: respuestaCrear.
! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 18:30:24'!
test02unaInterfazExternaRespondeExitosamenteAlCreaDosCarritos
	| unaInterfazExterna respuestaCrear otraRespuestaCrear |
	
	unaInterfazExterna := self interfazExternaConInterfazInternaQueHaceTodo.

	respuestaCrear := self interfazInterna: unaInterfazExterna
							  crearCarritoConCliente: ''
							  yContraseña: ''.

	otraRespuestaCrear := self interfazInterna: unaInterfazExterna
								   crearCarritoConCliente: ''
								   yContraseña: ''.

	self assertQueUnaRespuestaDeCrearUnCarritoEsValida: respuestaCrear.
	self assertQueUnaRespuestaDeCrearUnCarritoEsValida: otraRespuestaCrear
	! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 19:33:21'!
test03unaInterfazExternaRespondeExitosamenteAlAgregaUnLibro
	| unaInterfazExterna respuestaAgregar |
	
	unaInterfazExterna := self interfazExternaConInterfazInternaQueHaceTodo.

	respuestaAgregar := self interfazInterna: unaInterfazExterna
								 agregarAlCarrito: (self interfazInternaIDDeUnCarritoCreado: unaInterfazExterna)
								 IsbnDeLibro: self iSBNLibroExtremeProgramming
								 cantidadDeLibros: '1'.

	self assertRespuesta: respuestaAgregar
		  tieneStatus: InterfazExterna statusOK
		  yBody: InterfazExterna codigoDeExito, 'OK'
	

	! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 19:33:42'!
test04unaInterfazExternaRespondeUnErrorAlAgregaUnLibroQueNoEstaEnCatalogo
	| unaInterfazExterna respuestaAgregar |

	unaInterfazExterna := self interfazExternaConInterfazInternaConCatalogoVacio.

	respuestaAgregar := self interfazInterna: unaInterfazExterna
								 agregarAlCarrito: (self interfazInternaIDDeUnCarritoCreado: unaInterfazExterna)
								 IsbnDeLibro: self iSBNLibroExtremeProgramming
								 cantidadDeLibros: '1'.

	self assertRespuesta: respuestaAgregar
		  tieneStatus: InterfazExterna statusOK
		  yBody: InterfazExterna codigoDeError, 'Error: ', Carrito errorNoSePuedeAñadirLibroDescatalogado
	

	! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 19:34:03'!
test05unaInterfazExternaRespondeExitosamenteAlListaUnCarritoVacio
	| unaInterfazExterna respuestaListar |

	unaInterfazExterna := self interfazExternaConInterfazInternaQueHaceTodo.

	respuestaListar := self interfazExterna: unaInterfazExterna
								listar: (self interfazInternaIDDeUnCarritoCreado: unaInterfazExterna).
	
	self assertRespuesta: respuestaListar
		  tieneStatus: InterfazExterna statusOK
		  yBody: InterfazExterna codigoDeExito, ''
	

	! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 19:35:15'!
test06unaInterfazExternaRespondeExitosamenteAlListaUnCarritoConUnLibro
	| unaInterfazExterna iDDelCarrito respuestaListar |

	unaInterfazExterna := self interfazExternaConInterfazInternaQueHaceTodo.
	iDDelCarrito := self interfazInternaIDDeUnCarritoCreado: unaInterfazExterna.

	self interfazInterna: unaInterfazExterna
		  agregarAlCarrito: iDDelCarrito
		  IsbnDeLibro: self iSBNLibroExtremeProgramming 
		  cantidadDeLibros: '1'.
	respuestaListar := self interfazExterna: unaInterfazExterna
								listar: iDDelCarrito.
	
	self assertRespuesta: respuestaListar
		  tieneStatus: InterfazExterna statusOK
		  yBody: InterfazExterna codigoDeExito, self iSBNLibroExtremeProgramming, '|1'
	

	! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 18:51:46'!
test07unaInterfazExternaRespondeUnErrorAlListaUnCarritoSinCrearlo
	| unaInterfazExterna iDDelCarritoNoCreado respuestaListar |

	unaInterfazExterna := self interfazExternaConInterfazInternaQueHaceTodo.

	iDDelCarritoNoCreado := '1'.
	respuestaListar := self interfazExterna: unaInterfazExterna
								listar: iDDelCarritoNoCreado.
	
	self assertRespuesta: respuestaListar
		  tieneStatus: InterfazExterna statusOK
		  yBody: InterfazExterna codigoDeError, 'Error: ', InterfazInterna errorElCarritoNoFueCreado
	

	! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 20:16:42'!
test08unaInterfazExternaRespondeUnErrorAlCrearCarritoConUnaRequestInvalida

	self assertQueUnaInterfazExternaRespondeUnErrorAlUsarUnaRequestInvalida: [ :unaInterfazExterna :unPaqueteInvalido |
		unaInterfazExterna crearCarrito: unPaqueteInvalido
	]
	

	! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 20:16:40'!
test09unaInterfazExternaRespondeUnErrorAlListarConUnaRequestInvalida

	self assertQueUnaInterfazExternaRespondeUnErrorAlUsarUnaRequestInvalida: [ :unaInterfazExterna :unPaqueteInvalido |
		unaInterfazExterna listarCarrito: unPaqueteInvalido
	]
	

	! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 20:16:37'!
test10unaInterfazExternaRespondeUnErrorAlAgregarLibroConUnaRequestInvalida

	self assertQueUnaInterfazExternaRespondeUnErrorAlUsarUnaRequestInvalida: [ :unaInterfazExterna :unPaqueteInvalido |
		unaInterfazExterna agregarAlCarrito: unPaqueteInvalido
	]
	

	! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 19:36:35'!
test11unaInterfazExternaRespondeExitosamenteAlListaUnCarritoConMasDeUnaCopiaDeUnLibro
	| unaInterfazExterna iDDelCarrito respuestaListar |
	
	unaInterfazExterna := self interfazExternaConInterfazInternaQueHaceTodo.
	iDDelCarrito := self interfazInternaIDDeUnCarritoCreado: unaInterfazExterna.

	self interfazInterna: unaInterfazExterna
		  agregarAlCarrito: iDDelCarrito
		  IsbnDeLibro: self iSBNLibroExtremeProgramming
		  cantidadDeLibros: '2'.
	respuestaListar := self interfazExterna: unaInterfazExterna
								listar: iDDelCarrito.

	self assertRespuesta: respuestaListar
		  tieneStatus: InterfazExterna statusOK
		  yBody: InterfazExterna codigoDeExito, self iSBNLibroExtremeProgramming, '|2'.
	

	! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 18:57:56'!
test12unaInterfazExternaRespondeUnErrorAlCrearCarritoConUsuarioNoAutenticado
	| unaInterfazExterna respuestaCrear |

	unaInterfazExterna := self interfazExternaConInterfazInternaQueNoAutenticaNada.

	respuestaCrear := self interfazInterna: unaInterfazExterna
							  crearCarritoConCliente: ''
							  yContraseña: ''.

	self assertRespuesta: respuestaCrear
		  tieneStatus: InterfazExterna statusOK
		  yBody: InterfazExterna codigoDeError, 'Error: ', InterfazInterna errorCredencialesInvalidas 
! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 19:37:10'!
test13unaInterfazExternaRespondeUnErrorAlHacerCheckOutDeUnCarritoVacio
	| unaInterfazExterna respuestaCheckOut |

	unaInterfazExterna := self interfazExternaConInterfazInternaQueHaceTodo.

	respuestaCheckOut := self interfazInterna: unaInterfazExterna
								  checkOutAlCarrito: (self interfazInternaIDDeUnCarritoCreado: unaInterfazExterna)
								  ccnDeLaTarjeta: ''
								  ccedDeLaTarjeta: self mesDeAñoDeExpiracionValido
								  ccoDeLaTarjeta: ''.

	self assertRespuesta: respuestaCheckOut
		  tieneStatus: InterfazExterna statusOK
		  yBody: InterfazExterna codigoDeError, 'Error: ', Cajero errorNoSePuedeHacerCheckOutDeUnCarritoVacio ! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 19:37:44'!
test14unaInterfazExternaRespondeExitosamenteAlHacerCheckOutDeUnCarrito
	| unaInterfazExterna iDDelCarrito respuestaCheckOut |
	
	unaInterfazExterna := self interfazExternaConInterfazInternaQueHaceTodo.
	iDDelCarrito := self interfazInternaIDDeUnCarritoCreado: unaInterfazExterna.

	self interfazInterna: unaInterfazExterna
		  agregarAlCarrito: iDDelCarrito
		  IsbnDeLibro: self iSBNLibroExtremeProgramming
		  cantidadDeLibros: '1'.
	respuestaCheckOut := self interfazInterna: unaInterfazExterna
								  checkOutAlCarrito: iDDelCarrito
								  ccnDeLaTarjeta: ''
								  ccedDeLaTarjeta: self mesDeAñoDeExpiracionValido
								  ccoDeLaTarjeta: ''.
	
	self assertQueUnaRespuestaDeCheckOutDeUnCarritoEsValida: respuestaCheckOut.! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 20:16:28'!
test15unaInterfazExternaRespondeUnErrorAlHacerCheckOutConUnaRequestInvalida

	self assertQueUnaInterfazExternaRespondeUnErrorAlUsarUnaRequestInvalida: [ :unaInterfazExterna :unPaqueteInvalido |
		unaInterfazExterna checkOut: unPaqueteInvalido
	]
	

	! !

!InterfazExternaTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 21:06:27'!
test16unaInterfazExternaRespondeUnErrorAlHacerCheckOutConUnPaqueteConTarjetaConFechaDeExpiracionInvalida
	| unaInterfazExterna iDDelCarrito respuestaCheckOut mesDeAñoDeExpiracionInvalido |
	
	unaInterfazExterna := self interfazExternaConInterfazInternaQueHaceTodo.
	iDDelCarrito := self interfazInternaIDDeUnCarritoCreado: unaInterfazExterna.

	self interfazInterna: unaInterfazExterna
		  agregarAlCarrito: iDDelCarrito
		  IsbnDeLibro: self iSBNLibroExtremeProgramming
		  cantidadDeLibros: '1'.
	mesDeAñoDeExpiracionInvalido := '132023'.
	respuestaCheckOut := self interfazInterna: unaInterfazExterna
								  checkOutAlCarrito: iDDelCarrito
								  ccnDeLaTarjeta: ''
								  ccedDeLaTarjeta: mesDeAñoDeExpiracionInvalido
								  ccoDeLaTarjeta: ''.

	self assertRespuesta: respuestaCheckOut
		  tieneStatus: InterfazExterna statusOK
		  yBody: InterfazExterna codigoDeError, 'Error: ', InterfazExterna errorFechaDeExpiracionInvalida
	

	! !


!InterfazExternaTest methodsFor: 'assertions' stamp: 'S.V. 6/22/2024 20:14:24'!
assertQueUnaInterfazExternaRespondeUnErrorAlUsarUnaRequestInvalida: unClosureConUnaRequestARealizar
	| unaInterfazExterna unPaqueteInvalido respuesta |

	unaInterfazExterna := self interfazExternaConInterfazInternaQueHaceTodo.

	unPaqueteInvalido := Dictionary new.
	respuesta := unClosureConUnaRequestARealizar value: unaInterfazExterna value: unPaqueteInvalido.

	self assertRespuesta: respuesta
		  tieneStatus: InterfazExterna statusBadRequest
		  yBody: InterfazExterna codigoDeError, 'Error: ', InterfazExterna errorFormatoDeRequestInvalido

! !

!InterfazExternaTest methodsFor: 'assertions' stamp: 'S.V. 6/22/2024 20:30:51'!
assertQueUnaRespuestaDeCheckOutDeUnCarritoEsValida: unaRespuesta

	self assertQueUnaRespuestaExitosaTieneUnID: unaRespuesta

! !

!InterfazExternaTest methodsFor: 'assertions' stamp: 'S.V. 6/22/2024 20:30:53'!
assertQueUnaRespuestaDeCrearUnCarritoEsValida: unaRespuesta

	self assertQueUnaRespuestaExitosaTieneUnID: unaRespuesta

! !

!InterfazExternaTest methodsFor: 'assertions' stamp: 'S.V. 6/22/2024 20:30:55'!
assertQueUnaRespuestaExitosaTieneUnID: unaRespuesta

	self assert: (unaRespuesta at: 'status') equals: 200.
	self assert: ((unaRespuesta at: 'body') matchesRegex: '0\|.+')

! !

!InterfazExternaTest methodsFor: 'assertions' stamp: 'S.V. 6/22/2024 20:31:01'!
assertRespuesta: unaRespuesta tieneStatus: unStatus yBody: unBody

	self assert: (unaRespuesta at: 'status') equals: unStatus.
	self assert: (unaRespuesta at: 'body') equals: unBody
	
	! !


!InterfazExternaTest methodsFor: 'paquetes' stamp: 'S.V. 6/22/2024 20:24:23'!
crearPaqueteParaAgregarUnLibroConIdDeCarrito: unIdDeCarrito iSBNDeLibro: unIsbnDeLibro cantidadDeLibros: unaCantidad
	| paqueteParaAgregar |

	paqueteParaAgregar := Dictionary new.

	paqueteParaAgregar at: 'cartId' put: unIdDeCarrito;
						  at: 'bookIsbn' put: unIsbnDeLibro;
						  at: 'bookQuantity' put: unaCantidad.

	^ paqueteParaAgregar! !

!InterfazExternaTest methodsFor: 'paquetes' stamp: 'S.V. 6/22/2024 20:24:45'!
crearPaqueteParaCheckOutConIdDeCarrito: unIdDeCarrito ccnDeLaTarjeta: unCcn ccedDeLaTarjeta: unCced ccoDeLaTarjeta: unCco
	| paqueteParaCheckOut |

	paqueteParaCheckOut := Dictionary new.

	paqueteParaCheckOut at: 'cartId' put: unIdDeCarrito;
						   at: 'ccn' put: unCcn;
						   at: 'cced' put: unCced;
						   at: 'cco' put: unCco.

	^ paqueteParaCheckOut! !

!InterfazExternaTest methodsFor: 'paquetes' stamp: 'S.V. 6/22/2024 20:25:05'!
crearPaqueteParaCrearCarritoConCliente: unIdDeCliente yContraseña: unaContraseña
	| paqueteParaCrear |

	paqueteParaCrear := Dictionary new.

	paqueteParaCrear at: 'clientId' put: unIdDeCliente;
						at: 'password' put: unaContraseña.

	^ paqueteParaCrear! !

!InterfazExternaTest methodsFor: 'paquetes' stamp: 'S.V. 6/8/2024 14:43:24'!
crearPaqueteParaListarUnCarrito: unIdDeCarrito
	| paqueteParaListar |

	paqueteParaListar := Dictionary new.

	paqueteParaListar at: 'cartId' put: unIdDeCarrito.

	^ paqueteParaListar! !


!InterfazExternaTest methodsFor: 'private' stamp: 'S.V. 6/2/2024 20:58:40'!
idDeCarritoDe: respuestaBodyDeCrear

	^ respuestaBodyDeCrear copyFrom: 3 to: respuestaBodyDeCrear size! !

!InterfazExternaTest methodsFor: 'private' stamp: 'S.V. 6/8/2024 14:43:31'!
interfazExterna: unaInterfazExterna listar: iDDelCarrito
	| paqueteParaListar |

	paqueteParaListar := self crearPaqueteParaListarUnCarrito: iDDelCarrito.

	^ unaInterfazExterna listarCarrito: paqueteParaListar! !

!InterfazExternaTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:18:58'!
interfazInterna: unaInterfazExterna agregarAlCarrito: iDDelCarrito IsbnDeLibro: iSBNDelLibroAAgregar cantidadDeLibros: cantidadAAgregar
	| paqueteParaAgregar |

	paqueteParaAgregar := self crearPaqueteParaAgregarUnLibroConIdDeCarrito: iDDelCarrito
								   iSBNDeLibro: iSBNDelLibroAAgregar
								   cantidadDeLibros: cantidadAAgregar.

	^ unaInterfazExterna agregarAlCarrito: paqueteParaAgregar! !

!InterfazExternaTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 19:18:21'!
interfazInterna: unaInterfazExterna checkOutAlCarrito: iDDelCarrito ccnDeLaTarjeta: unCcn ccedDeLaTarjeta: unCced ccoDeLaTarjeta: unCco
	| paqueteParaCheckOut |

	paqueteParaCheckOut := self crearPaqueteParaCheckOutConIdDeCarrito: iDDelCarrito
									ccnDeLaTarjeta: unCcn
									ccedDeLaTarjeta: unCced
									ccoDeLaTarjeta: unCco.

	^ unaInterfazExterna checkOut: paqueteParaCheckOut.! !

!InterfazExternaTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 19:18:32'!
interfazInterna: unaInterfazExterna crearCarritoConCliente: unCliente yContraseña: unaContraseña
    | paqueteParaCrear |

    paqueteParaCrear := self crearPaqueteParaCrearCarritoConCliente: unCliente
								  yContraseña: unaContraseña.

    ^ unaInterfazExterna crearCarrito: paqueteParaCrear! !

!InterfazExternaTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 19:32:10'!
interfazInternaIDDeUnCarritoCreado: unaInterfazExterna
	| respuestaCrear iDDelCarrito |

	respuestaCrear := self interfazInterna: unaInterfazExterna
							  crearCarritoConCliente: ''
						      yContraseña: ''.
	iDDelCarrito := self idDeCarritoDe: (respuestaCrear at: 'body').

    ^ iDDelCarrito! !


!classDefinition: #InterfazInternaTest category: #TusLibros!
TestCase subclass: #InterfazInternaTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InterfazInternaTest methodsFor: 'merchant processors' stamp: 'S.V. 6/22/2024 20:33:15'!
stubMerchantProcessorQueCobraTodo

	^ [ :monto :tarjeta | ]! !

!InterfazInternaTest methodsFor: 'merchant processors' stamp: 'S.V. 6/22/2024 21:46:14'!
stubMerchantProcessorQueNoCobraNada

	^ [ :monto :tarjeta | self error: 'Stolen card!!' ]! !


!InterfazInternaTest methodsFor: 'autenticadores' stamp: 'S.V. 6/22/2024 20:33:12'!
stubAutenticadorQueAutenticaTodo

	^ [ :usuario :contraseña | ]
	! !

!InterfazInternaTest methodsFor: 'autenticadores' stamp: 'S.V. 6/22/2024 20:33:14'!
stubAutenticadorQueNoAutenticaNada

	^ [ :usuario :contraseña | self error: 'Invalid credentials' ]! !


!InterfazInternaTest methodsFor: 'catalogos' stamp: 'S.V. 6/22/2024 20:33:00'!
catalogoConExtremeProgramming
	| catalogo |

	catalogo := Dictionary new.
	catalogo at: self iSBNLibroExtremeProgramming put: 1.

	^ catalogo! !

!InterfazInternaTest methodsFor: 'catalogos' stamp: 'S.V. 6/22/2024 20:33:02'!
catalogoVacio
	| catalogo |

	catalogo := Dictionary new.

	^ catalogo! !

!InterfazInternaTest methodsFor: 'catalogos' stamp: 'S.V. 6/22/2024 20:33:10'!
iSBNLibroExtremeProgramming

	^ '9780201710915'! !


!InterfazInternaTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 17:23:41'!
test01unaInterfazInternaCreaUnCarritoYEmpiezaVacio
	| unaInterfazInterna IDDelCarrito |
	
	unaInterfazInterna := InterfazInterna newConSesionQueNoExpiraCatalogo: self catalogoVacio
												sistemaDeAutenticacion: self stubAutenticadorQueAutenticaTodo
												merchantProcessor: self stubMerchantProcessorQueCobraTodo.
	
	IDDelCarrito := unaInterfazInterna crearCarritoParaElUsuario: '' conContraseña: ''.
	
	self assert: (unaInterfazInterna listarCarrito: IDDelCarrito) isEmpty! !

!InterfazInternaTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 17:23:47'!
test02unaInterfazInternaLanzaUnErrorAlListarUnCarritoSinCrearlo
	| unaInterfazInterna IDDeUnCarritoNoCreado |
	
	unaInterfazInterna := InterfazInterna newConSesionQueNoExpiraCatalogo: self catalogoVacio
												sistemaDeAutenticacion: self stubAutenticadorQueAutenticaTodo
												merchantProcessor: self stubMerchantProcessorQueCobraTodo.

	IDDeUnCarritoNoCreado := 1.
	
	self should: [ unaInterfazInterna listarCarrito: IDDeUnCarritoNoCreado ]
		 raise: Error 
		 withExceptionDo: [ :anError |
			self assert: InterfazInterna errorElCarritoNoFueCreado equals: anError messageText.
		]! !

!InterfazInternaTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 17:23:53'!
test03unaInterfazInternaPuedeAgregarUnLibroYApareceAlListar
	| unaInterfazInterna IDDelCarrito listado |
	
	unaInterfazInterna := InterfazInterna newConSesionQueNoExpiraCatalogo: self catalogoConExtremeProgramming
												sistemaDeAutenticacion: self stubAutenticadorQueAutenticaTodo
												merchantProcessor: self stubMerchantProcessorQueCobraTodo.

	IDDelCarrito := unaInterfazInterna crearCarritoParaElUsuario: '' conContraseña: ''.
	unaInterfazInterna agregar: 1 libros: self iSBNLibroExtremeProgramming alCarrito: IDDelCarrito.
	
	listado := unaInterfazInterna listarCarrito: IDDelCarrito.
	
	self assert: listado size equals: 1.
	self assert: (listado includes: self iSBNLibroExtremeProgramming)
	
	! !

!InterfazInternaTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 17:23:59'!
test04unaInterfazInternaCreaDosCarritosDiferentes
	| unaInterfazInterna IDDeUnCarritoConLibro IDDeUnCarritoVacio |
	
	unaInterfazInterna := InterfazInterna newConSesionQueNoExpiraCatalogo: self catalogoConExtremeProgramming
												sistemaDeAutenticacion: self stubAutenticadorQueAutenticaTodo
												merchantProcessor: self stubMerchantProcessorQueCobraTodo.
	
	IDDeUnCarritoConLibro := unaInterfazInterna crearCarritoParaElUsuario: '' conContraseña: ''.
	IDDeUnCarritoVacio := unaInterfazInterna crearCarritoParaElUsuario: '' conContraseña: ''.
	
	unaInterfazInterna agregar: 1 libros: self iSBNLibroExtremeProgramming alCarrito: IDDeUnCarritoConLibro.
	
	self assert: IDDeUnCarritoConLibro ~= IDDeUnCarritoVacio.
	self assert: ((unaInterfazInterna listarCarrito: IDDeUnCarritoConLibro) includes: self iSBNLibroExtremeProgramming).
	self assert: (unaInterfazInterna listarCarrito: IDDeUnCarritoVacio) isEmpty! !

!InterfazInternaTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 17:24:07'!
test05unaInterfazInternaLanzaUnErrorAlAgregarUnLibroAUnCarritoSinCrearlo
	| unaInterfazInterna IDDeUnCarritoNoCreado |

	unaInterfazInterna := InterfazInterna newConSesionQueNoExpiraCatalogo: self catalogoConExtremeProgramming
												sistemaDeAutenticacion: self stubAutenticadorQueAutenticaTodo
												merchantProcessor: self stubMerchantProcessorQueCobraTodo.
	
	IDDeUnCarritoNoCreado := 1.
	
	self should: [
		unaInterfazInterna agregar: 1 libros: self iSBNLibroExtremeProgramming alCarrito: IDDeUnCarritoNoCreado
	]
		 raise: Error 
		 withExceptionDo: [ :anError |
			self assert: InterfazInterna errorElCarritoNoFueCreado equals: anError messageText.
		]
	! !

!InterfazInternaTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 17:24:12'!
test06unaInterfazInternaPuedeAgregarMasDeUnLibroYApareceAlListar
	| unaInterfazInterna IDDelCarrito listado |

	unaInterfazInterna := InterfazInterna newConSesionQueNoExpiraCatalogo: self catalogoConExtremeProgramming
												sistemaDeAutenticacion: self stubAutenticadorQueAutenticaTodo
												merchantProcessor: self stubMerchantProcessorQueCobraTodo.
	
	IDDelCarrito := unaInterfazInterna crearCarritoParaElUsuario: '' conContraseña: ''.
	
	unaInterfazInterna agregar: 2 libros: self iSBNLibroExtremeProgramming alCarrito: IDDelCarrito.
	
	listado := unaInterfazInterna listarCarrito: IDDelCarrito.
	
	self assert: (listado includes: self iSBNLibroExtremeProgramming).
	self assert: (listado occurrencesOf: self iSBNLibroExtremeProgramming) equals: 2
	
	! !

!InterfazInternaTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 17:24:18'!
test07unaInterfazInternaNoPuedeCrearUnCarritoSiElUsuarioNoEstaRegistrado
	| unaInterfazInterna |

	unaInterfazInterna := InterfazInterna newConSesionQueNoExpiraCatalogo: self catalogoVacio
												sistemaDeAutenticacion: self stubAutenticadorQueNoAutenticaNada
												merchantProcessor: self stubMerchantProcessorQueCobraTodo.

	self should: [
		unaInterfazInterna crearCarritoParaElUsuario: '' conContraseña: ''.
	]
		 raise: Error 
		 withExceptionDo: [ :anError |
			self assert: InterfazInterna errorCredencialesInvalidas equals: anError messageText.
		]
	
! !

!InterfazInternaTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 17:24:23'!
test08unaInterfazInternaLanzaUnErrorAlHacerCheckOutDeUnCarritoSinCrearlo
	| unaInterfazInterna IDDeUnCarritoNoCreado |

	unaInterfazInterna := InterfazInterna newConSesionQueNoExpiraCatalogo: self catalogoVacio
												sistemaDeAutenticacion: self stubAutenticadorQueAutenticaTodo
												merchantProcessor: self stubMerchantProcessorQueCobraTodo.
	
	IDDeUnCarritoNoCreado := 1.
	
	self should: [
		unaInterfazInterna
			checkOutDelCarrito: IDDeUnCarritoNoCreado 
			conNumeroDeTarjeta: ''
			conMesDeAñoExpiracion: 1
			conNombre: ''
	]
		 raise: Error 
		 withExceptionDo: [ :anError |
			self assert: InterfazInterna errorElCarritoNoFueCreado equals: anError messageText.
		]! !

!InterfazInternaTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 17:24:28'!
test09unaInterfazInternaPuedeHacerCheckOutDeUnCarritoYApareceEnLibroDeVentas
	| unaInterfazInterna IDDelCarrito IDDeTransaccion |

	unaInterfazInterna := InterfazInterna newConSesionQueNoExpiraCatalogo: self catalogoConExtremeProgramming
												sistemaDeAutenticacion: self stubAutenticadorQueAutenticaTodo
												merchantProcessor: self stubMerchantProcessorQueCobraTodo.
	
	IDDelCarrito := unaInterfazInterna crearCarritoParaElUsuario: '' conContraseña: ''.
	unaInterfazInterna agregar: 1 libros: self iSBNLibroExtremeProgramming alCarrito: IDDelCarrito.
	
	IDDeTransaccion := unaInterfazInterna
			checkOutDelCarrito: IDDelCarrito 
			conNumeroDeTarjeta: ''
			conMesDeAñoExpiracion: GregorianMonthOfYear current
			conNombre: ''.
			
	self assert: (unaInterfazInterna tieneCompraResgistradaCon: IDDeTransaccion)
! !

!InterfazInternaTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 17:24:34'!
test10unaInterfazInternaNoPuedeHacerCheckOutDeUnCarritoSiFallaElMerchantProcessorYNoApareceEnElLibroDeVentas
	| unaInterfazInterna IDDelCarrito IDDeTransaccion |

	unaInterfazInterna := InterfazInterna newConSesionQueNoExpiraCatalogo: self catalogoConExtremeProgramming
												sistemaDeAutenticacion: self stubAutenticadorQueAutenticaTodo
												merchantProcessor: self stubMerchantProcessorQueNoCobraNada.

	IDDelCarrito := unaInterfazInterna crearCarritoParaElUsuario: '' conContraseña: ''.
	unaInterfazInterna agregar: 1 libros: self iSBNLibroExtremeProgramming alCarrito: IDDelCarrito.

	self should: [
		IDDeTransaccion := unaInterfazInterna
			checkOutDelCarrito: IDDelCarrito 
			conNumeroDeTarjeta: ''
			conMesDeAñoExpiracion: GregorianMonthOfYear current
			conNombre: ''
	]
		 raise: Error 
		 withExceptionDo: [ :anError |
			self assert: Cajero errorNoSePudoRealizarElCobro equals: anError messageText.
		].

	self deny: (unaInterfazInterna tieneCompraResgistradaCon: IDDeTransaccion)! !

!InterfazInternaTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 18:19:38'!
test11unaInterfazInternaBorraElCarritoSiLaSesionExpiro
	| unaInterfazInterna IDDelCarrito |

	unaInterfazInterna := InterfazInterna newConSesionesExpiradasCatalogo: self catalogoConExtremeProgramming
												sistemaDeAutenticacion: self stubAutenticadorQueAutenticaTodo
												merchantProcessor: self stubMerchantProcessorQueNoCobraNada.

	IDDelCarrito := unaInterfazInterna crearCarritoParaElUsuario: '' conContraseña: ''.

	self should: [ unaInterfazInterna listarCarrito: IDDelCarrito ]
		  raise: Error 
		  withExceptionDo: [ :anError |
			 self assert: Sesion errorSesionExpirada equals: anError messageText.
		 ].

	self should: [ unaInterfazInterna listarCarrito: IDDelCarrito ]
		  raise: Error
		  withExceptionDo: [ :anError |
			 self assert: InterfazInterna errorElCarritoNoFueCreado equals: anError messageText.
		 ]! !


!classDefinition: #ReciboTest category: #TusLibros!
TestCase subclass: #ReciboTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!ReciboTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:27:22'!
libroExtremeProgramming

	^ #ExtremeProgramming! !

!ReciboTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:27:26'!
listaDeComprasConDosExtremeProgramming
	| listaDeCompras |

	listaDeCompras := self listaDeComprasConExtremeProgramming.
	listaDeCompras add: self libroExtremeProgramming.

	^ listaDeCompras! !

!ReciboTest methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:27:28'!
listaDeComprasConExtremeProgramming
	| listaDeCompras |

	listaDeCompras := Bag new.
	listaDeCompras add: self libroExtremeProgramming.

	^ listaDeCompras! !


!ReciboTest methodsFor: 'testing' stamp: 'S.V. 6/21/2024 16:57:27'!
test01unReciboSabeQueLibrosFueronComprados
	| unRecibo librosComprados |

	unRecibo := Recibo newConPrecioTotal: 1
						  ylistaDeCompra: self listaDeComprasConExtremeProgramming.
	
	librosComprados := unRecibo librosComprados.
	
	self assert: librosComprados includes: self libroExtremeProgramming. 
	self assert: librosComprados size equals: 1! !

!ReciboTest methodsFor: 'testing' stamp: 'S.V. 6/22/2024 21:29:41'!
test02unReciboSabeLaCantidadDeCadaLibroComprado
	| unRecibo |
	
	unRecibo := Recibo newConPrecioTotal: 1
				         ylistaDeCompra: self listaDeComprasConDosExtremeProgramming.
	
	self assert: (unRecibo cuantosComproDe: self libroExtremeProgramming) equals: 2.! !


!classDefinition: #SesionTest category: #TusLibros!
TestCase subclass: #SesionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!SesionTest methodsFor: 'private' stamp: 'S.V. 6/23/2024 16:20:20'!
treintaMinutos
	^ TimeUnits minute with: 30! !

!SesionTest methodsFor: 'private' stamp: 'S.V. 6/23/2024 16:21:59'!
treintayunMinutos
	^ TimeUnits minute with: 31! !

!SesionTest methodsFor: 'private' stamp: 'S.V. 6/23/2024 16:20:35'!
veintinueveMinutos
	^ TimeUnits minute with: 29! !


!SesionTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 18:33:02'!
test01unaSesionNoExpiranSiNoPasoSuTiempoDeExpiracion
	| unaSesion |

	unaSesion := Sesion newCon: '' conTiempoDeSesion: self treintaMinutos.
	
	self deny: unaSesion estaExpirada! !

!SesionTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 18:32:57'!
test02unaSesionExpiranPasadoSuTiempoDeExpiracion
	| unaSesion |

	unaSesion := Sesion newCon: '' conTiempoDeSesion: self treintaMinutos.
	
	unaSesion pasarTiempo: self treintayunMinutos.
	
	self assert: unaSesion estaExpirada! !

!SesionTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 18:32:53'!
test03unaSesionSeRenuevaSiSeAccedeAntesDeQuePaseSuTiempoDeExpiracion
	| unaSesion |

	unaSesion := Sesion newCon: '' conTiempoDeSesion: self treintaMinutos.
	
	unaSesion pasarTiempo: self veintinueveMinutos.
	unaSesion acceder.
	unaSesion pasarTiempo: self veintinueveMinutos.
	
	self deny: unaSesion estaExpirada! !

!SesionTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 18:32:41'!
test04unaSesionLanzaUnErrorSiSeIntentaAccederPasadoSuTiempoDeExpiracion
	| unaSesion |

	unaSesion := Sesion newCon: '' conTiempoDeSesion: self treintaMinutos.

	unaSesion pasarTiempo: self treintayunMinutos.
	
	self should: [
		unaSesion acceder
	]
		 raise: Error 
		 withExceptionDo: [ :anError |
			self assert: Sesion errorSesionExpirada equals: anError messageText.
		]
! !

!SesionTest methodsFor: 'testing' stamp: 'S.V. 6/23/2024 18:32:22'!
test05unaSesionPuedeAccederASuContenidoSiNoPasoSuTiempoDeExpiracion
	| unaSesion unContenido |

	unContenido := 1.
	unaSesion := Sesion newCon: unContenido conTiempoDeSesion: self treintaMinutos.

	self assert: unaSesion acceder equals: unContenido.
! !


!classDefinition: #TarjetaDeCreditoTests category: #TusLibros!
TestCase subclass: #TarjetaDeCreditoTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TarjetaDeCreditoTests methodsFor: 'testing' stamp: 'S.V. 6/21/2024 17:12:41'!
test01unaTarjetaDeCreditoSabeResponderSiEstaVencida
	| unaTarjeta unaFechaDeVencimiento |
	
	unaFechaDeVencimiento := GregorianMonthOfYear decemberOf: (GregorianYear number: 2000).
	
	unaTarjeta := TarjetaDeCredito newConNumeroDeTarjeta: 1
										conMesDeAñoDeExpiracion: unaFechaDeVencimiento
										conTitular: ''.
	
	self assert: unaTarjeta estaVencida! !

!TarjetaDeCreditoTests methodsFor: 'testing' stamp: 'S.V. 6/21/2024 17:13:40'!
test02unaTarjetaDeCreditoSabeResponderSiNoEstaVencida
	| unaTarjeta unaFechaDeVencimiento |
	
	unaFechaDeVencimiento := GregorianMonthOfYear current.
	
	unaTarjeta := TarjetaDeCredito newConNumeroDeTarjeta: 1
										conMesDeAñoDeExpiracion: unaFechaDeVencimiento
										conTitular: ''.
	
	self deny: unaTarjeta estaVencida! !

!TarjetaDeCreditoTests methodsFor: 'testing' stamp: 'S.V. 6/23/2024 18:22:20'!
test03unaTarjetaDeCreditoSabeResponderSuNumero
	| unaTarjeta unaFechaDeVencimiento |
	
	unaFechaDeVencimiento := GregorianMonthOfYear current.
	
	unaTarjeta := TarjetaDeCredito newConNumeroDeTarjeta: 1
										conMesDeAñoDeExpiracion: unaFechaDeVencimiento
										conTitular: ''.
	
	self assert: unaTarjeta number equals: 1! !


!classDefinition: #Cajero category: #TusLibros!
Object subclass: #Cajero
	instanceVariableNames: 'merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cajero methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:27:38'!
calcularPrecioTotalDe: listaDeCompra aPartirDe: unCatalogoParaVerificarPrecios
	| precioTotal |

	precioTotal := 0.
	listaDeCompra do: [ :unLibro | 
		| precioPorUnidad |
		precioPorUnidad := unCatalogoParaVerificarPrecios at: unLibro.
		precioTotal := precioTotal + precioPorUnidad 
	].

	^ precioTotal! !

!Cajero methodsFor: 'private' stamp: 'S.V. 6/23/2024 17:55:46'!
cobrar: precioTotal de: unaTarjeta

	[ merchantProcessor value: precioTotal value: unaTarjeta ]
		on: Error
		do: [
			self error: self class errorNoSePudoRealizarElCobro
		]! !


!Cajero methodsFor: 'public' stamp: 'S.V. 6/22/2024 20:27:42'!
checkOutDelCarrito: unCarrito delCatalogo: unCatalogoParaVerificarPrecios conTarjeta: unaTarjeta
	| listaDeCompra precioTotal |

	unCarrito estaVacio ifTrue: [ self error: self class errorNoSePuedeHacerCheckOutDeUnCarritoVacio ].
	unaTarjeta estaVencida ifTrue: [ self error: self class errorTarjetaDeCreditoVencida ].

	listaDeCompra := unCarrito listar.
	precioTotal := self calcularPrecioTotalDe: listaDeCompra aPartirDe: unCatalogoParaVerificarPrecios.

	self cobrar: precioTotal de: unaTarjeta.
	
	unCarrito vaciar.
	
	^ Recibo newConPrecioTotal: precioTotal ylistaDeCompra: listaDeCompra 
	! !


!Cajero methodsFor: 'initialization' stamp: 'S.V. 6/22/2024 20:27:46'!
merchantProcessor: unClosureQueCobra

	merchantProcessor := unClosureQueCobra! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cajero class' category: #TusLibros!
Cajero class
	instanceVariableNames: ''!

!Cajero class methodsFor: 'errors' stamp: 'S.V. 6/14/2024 20:22:08'!
errorNoSePudoRealizarElCobro
	^ 'No se pudo realizar el cobro'! !

!Cajero class methodsFor: 'errors' stamp: 'L.L 6/11/2024 20:42:20'!
errorNoSePuedeHacerCheckOutDeUnCarritoVacio
	^ 'No se puede hacer checkOut de un carrito vacio.'! !

!Cajero class methodsFor: 'errors' stamp: 'S.V. 6/14/2024 18:26:08'!
errorTarjetaDeCreditoVencida 
	^ 'Tarjeta de credito vencida.'! !


!Cajero class methodsFor: 'instance creation' stamp: 'S.V. 6/14/2024 20:15:26'!
newConMerchantProcessor: unMerchantProcessor
	^ self new merchantProcessor: unMerchantProcessor! !


!classDefinition: #Carrito category: #TusLibros!
Object subclass: #Carrito
	instanceVariableNames: 'libros'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Carrito methodsFor: 'initialization' stamp: 'S.V. 6/22/2024 20:28:29'!
initialize

	libros := Bag new! !


!Carrito methodsFor: 'public' stamp: 'S.V. 6/8/2024 19:41:11'!
añadir: unLibroAAñadir cantidadDeCopias: unaCantidadDeCopias delCatalogo: unCatalogoParaVerificar

	(unaCantidadDeCopias <= 0) ifTrue: [
		self error: self class errorNoSePuedeAgregarMenosDeUnaCopiaDeUnLibro 
	].

	unaCantidadDeCopias timesRepeat: [
		self añadir: unLibroAAñadir delCatalogo: unCatalogoParaVerificar
	]! !

!Carrito methodsFor: 'public' stamp: 'L.L 6/11/2024 21:39:29'!
añadir: unLibroAAñadir delCatalogo: unCatalogoParaVerificar
	
	(unCatalogoParaVerificar includesKey: unLibroAAñadir) ifFalse: [
		self error: self class errorNoSePuedeAñadirLibroDescatalogado
	].

	libros add: unLibroAAñadir! !

!Carrito methodsFor: 'public' stamp: 'S.V. 6/8/2024 19:41:16'!
estaVacio

	^ libros isEmpty! !

!Carrito methodsFor: 'public' stamp: 'S.V. 6/8/2024 19:41:18'!
incluye: unLibroAVerificar

	^ libros includes: unLibroAVerificar! !

!Carrito methodsFor: 'public' stamp: 'S.V. 6/8/2024 19:41:21'!
listar

	^ libros copy
	! !

!Carrito methodsFor: 'public' stamp: 'S.V. 6/17/2024 19:23:34'!
vaciar
	libros := Bag new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Carrito class' category: #TusLibros!
Carrito class
	instanceVariableNames: ''!

!Carrito class methodsFor: 'error' stamp: 'S.V. 6/4/2024 20:53:14'!
errorNoSePuedeAgregarMenosDeUnaCopiaDeUnLibro
	^ 'No se puede agregar menos de una copia de un libro.'
	! !

!Carrito class methodsFor: 'error' stamp: 'S.V. 5/21/2024 21:08:49'!
errorNoSePuedeAñadirLibroDescatalogado
	^ 'No se pueden añadir libros descatalogados.'
	! !


!classDefinition: #InterfazExterna category: #TusLibros!
Object subclass: #InterfazExterna
	instanceVariableNames: 'interfazInterna'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InterfazExterna methodsFor: 'private' stamp: 'S.V. 6/22/2024 21:00:29'!
crearMesDeAñoDeExpiracion: unaFechaDeExpiracion
	| numeroDeAño numeroDeMes mesDeAñoDeVencimiento |

	[
		numeroDeMes  := (unaFechaDeExpiracion copyFrom: 1 to: 2) asNumber.
		numeroDeAño := (unaFechaDeExpiracion copyFrom: 3 to: 6) asNumber.
		mesDeAñoDeVencimiento := GregorianMonthOfYear year: (GregorianYear number: numeroDeAño)
															 month: (GregorianMonth numbered: numeroDeMes).

		^ mesDeAñoDeVencimiento

	] on: Error do: [ self error: self class errorFechaDeExpiracionInvalida ]! !

!InterfazExterna methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:30:30'!
formatearLista: librosAFormatear
	| stringLista |

	stringLista := String new.
	librosAFormatear asSet do: [ :unLibro |
		| stringCantidad |

		stringCantidad := (librosAFormatear contents at: unLibro) asString.
		stringLista := (stringLista, unLibro, '|', stringCantidad, '|')
	].

	^ stringLista allButLast.! !

!InterfazExterna methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:30:33'!
interfazInterna: unaInterfazInterna

	interfazInterna := unaInterfazInterna! !

!InterfazExterna methodsFor: 'private' stamp: 'S.V. 6/22/2024 21:07:35'!
manejarRequest: unaRequest parametros: unaListaDeParametros ejecutar: unBloque
	| valoresDeParametros |

	[ 
		valoresDeParametros := unaListaDeParametros collect: [ :parametro |
			unaRequest at: parametro
		].
	
	] on: Error do: [
		^ self respuestaConStatus: self class statusBadRequest yBody: (self class codigoDeError, 'Error: ', InterfazExterna errorFormatoDeRequestInvalido)
	].

	[ 
		^ unBloque valueWithArguments: valoresDeParametros
	] on: Error do: [ :error |
		^ self respuestaConStatus: self class statusOK yBody: self class codigoDeError, error description
	].! !

!InterfazExterna methodsFor: 'private' stamp: 'S.V. 6/8/2024 18:30:56'!
respuestaConStatus: unStatus yBody: unBody
	| respuesta |

	respuesta := Dictionary new.
	respuesta at: 'status' put: unStatus.
	respuesta at: 'body' put: unBody.

	^ respuesta! !


!InterfazExterna methodsFor: 'public' stamp: 'S.V. 6/22/2024 20:29:08'!
agregarAlCarrito: requestParaAgregar

	^ self manejarRequest: requestParaAgregar
		parametros: #('cartId' 'bookIsbn' 'bookQuantity')
		ejecutar: [ :cartId :bookIsbn :bookQuantity |
			interfazInterna agregar: bookQuantity asNumber libros: bookIsbn alCarrito: cartId.
			self respuestaConStatus: self class statusOK yBody: self class codigoDeExito, 'OK'
		].! !

!InterfazExterna methodsFor: 'public' stamp: 'S.V. 6/22/2024 21:01:35'!
checkOut: requestParaCheckOut

	^ self manejarRequest: requestParaCheckOut
		parametros: #('cartId' 'ccn' 'cced' 'cco')
		ejecutar: [ :cartId :ccn :cced :cco |
			| idDeTransaccion mesDeAñoDeExpiracion |
			mesDeAñoDeExpiracion := self crearMesDeAñoDeExpiracion: cced.
			idDeTransaccion := interfazInterna checkOutDelCarrito: cartId conNumeroDeTarjeta: ccn conMesDeAñoExpiracion: mesDeAñoDeExpiracion conNombre: cco.
			self respuestaConStatus: self class statusOK yBody: self class codigoDeExito, idDeTransaccion
		].! !

!InterfazExterna methodsFor: 'public' stamp: 'S.V. 6/22/2024 20:29:12'!
crearCarrito: requestParaCrear

	^ self manejarRequest: requestParaCrear
		parametros: #('clientId' 'password')
		ejecutar: [ :clientId :password |
			| idDelCarritoCreado |
			idDelCarritoCreado := interfazInterna crearCarritoParaElUsuario: clientId conContraseña: password.
			self respuestaConStatus: self class statusOK yBody: self class codigoDeExito, idDelCarritoCreado
		].! !

!InterfazExterna methodsFor: 'public' stamp: 'S.V. 6/22/2024 20:30:36'!
listarCarrito: requestParaListar

	^ self manejarRequest: requestParaListar
		parametros: #('cartId')
		ejecutar: [ :cartId |
			| libros |
			libros := interfazInterna listarCarrito: cartId.
			self respuestaConStatus: self class statusOK yBody: self class codigoDeExito, (self formatearLista: libros)
		].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InterfazExterna class' category: #TusLibros!
InterfazExterna class
	instanceVariableNames: ''!

!InterfazExterna class methodsFor: 'error' stamp: 'S.V. 6/22/2024 21:00:50'!
errorFechaDeExpiracionInvalida
	^ 'Error fecha de expiracion invalida.'! !

!InterfazExterna class methodsFor: 'error' stamp: 'S.V. 6/2/2024 20:27:07'!
errorFormatoDeRequestInvalido
	^ 'Error formato de request invalido.'! !


!InterfazExterna class methodsFor: 'instance creation' stamp: 'S.V. 5/28/2024 19:18:36'!
newCon: unaInterfazInterna
	^ self new interfazInterna: unaInterfazInterna! !


!InterfazExterna class methodsFor: 'status' stamp: 'S.V. 6/8/2024 19:07:23'!
statusBadRequest
	^ 400! !

!InterfazExterna class methodsFor: 'status' stamp: 'S.V. 6/8/2024 19:06:57'!
statusOK
	^ 200! !


!InterfazExterna class methodsFor: 'codigos' stamp: 'S.V. 6/8/2024 19:07:10'!
codigoDeError
	^ '1|'! !

!InterfazExterna class methodsFor: 'codigos' stamp: 'S.V. 6/8/2024 19:07:16'!
codigoDeExito
	^ '0|'! !


!classDefinition: #InterfazInterna category: #TusLibros!
Object subclass: #InterfazInterna
	instanceVariableNames: 'sesiones catalogo sistemaDeAutenticacion libroDeVentas merchantProcessor medidaDeTiempoDeSesion'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InterfazInterna methodsFor: 'private' stamp: 'S.V. 6/14/2024 19:55:54'!
agregarReciboAlLibroDeVentas: unReciboDeCompra
	| iD |
	
	iD := self nuevoID.
	libroDeVentas at: iD put: unReciboDeCompra.

	^ iD! !

!InterfazInterna methodsFor: 'private' stamp: 'S.V. 6/17/2024 19:17:43'!
autenticarUsuario: unUsuarioAAutenticar conContraseña: unaContraseñaAAutenticar

	[ sistemaDeAutenticacion value: unUsuarioAAutenticar value: unaContraseñaAAutenticar ]
		on: Error
		do: [
			self error: self class errorCredencialesInvalidas
		].! !

!InterfazInterna methodsFor: 'private' stamp: 'S.V. 6/23/2024 17:26:15'!
buscarCarrito: iDDelCarritoABuscar
	| sesion |

	sesion := sesiones at: iDDelCarritoABuscar
		ifAbsent: [
			self error: self class errorElCarritoNoFueCreado
		].

	[ ^ sesion acceder ] on: Error do: [ :anError |
		sesiones removeKey: iDDelCarritoABuscar.
		self error: anError messageText
	]
	! !

!InterfazInterna methodsFor: 'private' stamp: 'S.V. 6/8/2024 19:23:16'!
nuevoID

	^ (UUIDGenerator default generateRandomBitsOfLength: 32) asString! !


!InterfazInterna methodsFor: 'public' stamp: 'S.V. 6/23/2024 16:41:39'!
agregar: unaCantidadAAgregar libros: iSBNDeUnLibro alCarrito: iDDelCarrito
	| carrito |

	carrito := self buscarCarrito: iDDelCarrito.
	
	carrito añadir: iSBNDeUnLibro cantidadDeCopias: unaCantidadAAgregar delCatalogo: catalogo.
	
	
	
! !

!InterfazInterna methodsFor: 'public' stamp: 'S.V. 6/23/2024 16:41:36'!
checkOutDelCarrito: iDDeUnCarrito
conNumeroDeTarjeta: unNumeroDeTarjeta
conMesDeAñoExpiracion: unMesDeAñoDeExpiracion
conNombre: unNombreDeTitular
	| carrito tarjetaDeCredito cajero unRecibo idDeTransaccion |
	
	carrito := self buscarCarrito: iDDeUnCarrito.
	
	tarjetaDeCredito := TarjetaDeCredito newConNumeroDeTarjeta: unNumeroDeTarjeta conMesDeAñoDeExpiracion: unMesDeAñoDeExpiracion conTitular: unNombreDeTitular.
	
	cajero := Cajero newConMerchantProcessor: merchantProcessor.
	
	unRecibo := cajero checkOutDelCarrito: carrito delCatalogo: catalogo conTarjeta: tarjetaDeCredito.
	
	idDeTransaccion := self agregarReciboAlLibroDeVentas: unRecibo.
	
	^ idDeTransaccion

! !

!InterfazInterna methodsFor: 'public' stamp: 'S.V. 6/23/2024 18:04:12'!
crearCarritoParaElUsuario: unUsuario conContraseña: unaContraseña
	| iD |

	self autenticarUsuario: unUsuario conContraseña: unaContraseña.

	iD := self nuevoID.
	sesiones at: iD put: (Sesion newCon: Carrito new conTiempoDeSesion: medidaDeTiempoDeSesion).

	^ iD! !

!InterfazInterna methodsFor: 'public' stamp: 'S.V. 6/23/2024 16:41:29'!
listarCarrito: iDDelCarritoAListar
	| carrito |

	carrito := self buscarCarrito: iDDelCarritoAListar.

	^ carrito listar! !

!InterfazInterna methodsFor: 'public' stamp: 'S.V. 6/22/2024 21:23:45'!
tieneCompraResgistradaCon: IDDeTransaccion

	^ libroDeVentas includesKey: IDDeTransaccion! !


!InterfazInterna methodsFor: 'initialization' stamp: 'S.V. 6/23/2024 18:03:52'!
conCatalogo: unCatalogoAVerificar
sistemaDeAutenticacion: unClosureQueAutenticaUnUsuarioYContraseña
merchantProcessor: unClosureQueCobra
yTiempoDeSesion: unaMedidaDeTiempoDeSesion

	catalogo := unCatalogoAVerificar.
	sistemaDeAutenticacion := unClosureQueAutenticaUnUsuarioYContraseña.
	merchantProcessor := unClosureQueCobra.
	medidaDeTiempoDeSesion := unaMedidaDeTiempoDeSesion! !

!InterfazInterna methodsFor: 'initialization' stamp: 'S.V. 6/23/2024 18:37:17'!
initialize

	catalogo := Set new.
	libroDeVentas := Dictionary new.
	sesiones := Dictionary new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InterfazInterna class' category: #TusLibros!
InterfazInterna class
	instanceVariableNames: ''!

!InterfazInterna class methodsFor: 'errors' stamp: 'L.L 6/10/2024 09:33:36'!
errorCredencialesInvalidas
	^ 'Credenciales invalidas, Nombre de usuario o contrasena invalidos'! !

!InterfazInterna class methodsFor: 'errors' stamp: 'L.L 6/10/2024 09:34:10'!
errorElCarritoNoFueCreado
	^ 'El carrito no fue creado'! !

!InterfazInterna class methodsFor: 'errors' stamp: 'S.V. 6/17/2024 18:50:51'!
errorSesionExpirada
	^ 'Sesion expirada'! !


!InterfazInterna class methodsFor: 'instance creation' stamp: 'S.V. 6/23/2024 16:33:16'!
newConCatalogo: unCatalogoAVerificar
sistemaDeAutenticacion: unClosureQueAutenticaUnUsuarioYContraseña
merchantProcessor: unClosureQueCobra
yTiempoDeSesion: unaMedidaDeTiempoDeSesion

	^ self new conCatalogo: unCatalogoAVerificar
				 sistemaDeAutenticacion: unClosureQueAutenticaUnUsuarioYContraseña
				 merchantProcessor: unClosureQueCobra
				 yTiempoDeSesion: unaMedidaDeTiempoDeSesion! !

!InterfazInterna class methodsFor: 'instance creation' stamp: 'S.V. 6/23/2024 18:05:40'!
newConSesionQueNoExpiraCatalogo: unCatalogoAVerificar
sistemaDeAutenticacion: unClosureQueAutenticaUnUsuarioYContraseña
merchantProcessor: unClosureQueCobra

	^ self new conCatalogo: unCatalogoAVerificar
				 sistemaDeAutenticacion: unClosureQueAutenticaUnUsuarioYContraseña
				 merchantProcessor: unClosureQueCobra
				 yTiempoDeSesion: (GregorianDateTime now distanceTo: GregorianDateTime theEndOfTime)! !

!InterfazInterna class methodsFor: 'instance creation' stamp: 'S.V. 6/23/2024 18:30:01'!
newConSesionesExpiradasCatalogo: unCatalogoAVerificar
sistemaDeAutenticacion: unClosureQueAutenticaUnUsuarioYContraseña
merchantProcessor: unClosureQueCobra

	^ self new conCatalogo: unCatalogoAVerificar
				 sistemaDeAutenticacion: unClosureQueAutenticaUnUsuarioYContraseña
				 merchantProcessor: unClosureQueCobra
				 yTiempoDeSesion: (TimeUnits second with: -1)! !


!classDefinition: #Recibo category: #TusLibros!
Object subclass: #Recibo
	instanceVariableNames: 'precioTotal listaDeCompra'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Recibo methodsFor: 'public' stamp: 'S.V. 6/22/2024 20:33:31'!
cuantosComproDe: unLibro

	^ listaDeCompra occurrencesOf: unLibro ! !

!Recibo methodsFor: 'public' stamp: 'S.V. 6/22/2024 20:33:34'!
librosComprados

	^ listaDeCompra asSet! !

!Recibo methodsFor: 'public' stamp: 'S.V. 6/22/2024 20:33:38'!
tienePrecioTotal: unPrecioTotal

	^ precioTotal = unPrecioTotal ! !


!Recibo methodsFor: 'initialization' stamp: 'S.V. 6/21/2024 16:53:56'!
precioTotal: unPrecioTotal 
yListaDeCompra: unaListaDeCompra

	precioTotal := unPrecioTotal.
	listaDeCompra := unaListaDeCompra
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Recibo class' category: #TusLibros!
Recibo class
	instanceVariableNames: ''!

!Recibo class methodsFor: 'as yet unclassified' stamp: 'S.V. 6/21/2024 16:53:23'!
newConPrecioTotal: unPrecioTotal ylistaDeCompra: unaListaDeCompra
	^ self new precioTotal: unPrecioTotal 
				 yListaDeCompra: unaListaDeCompra! !


!classDefinition: #ServidorWeb category: #TusLibros!
Object subclass: #ServidorWeb
	instanceVariableNames: 'interfazExterna servidor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!ServidorWeb methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:33:52'!
catalogo
	|catalogo|

	catalogo := Dictionary new.
	catalogo at: '9780137314942' put: 31505;
			  at: '9780321278654' put: 45305;
			  at: '9780201710915' put: 45180; 
			  at: '9780321125217' put: 41000;
			  at: '9780735619654' put: 34900;
			  at: '9780321146533' put: 29100.

	^ catalogo ! !

!ServidorWeb methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:34:02'!
escucharEnPuerto: unPuerto

	servidor listenOn: unPuerto.
	servidor useDebugErrorHandler.
	
	^ servidor! !

!ServidorWeb methodsFor: 'private' stamp: 'S.V. 6/23/2024 16:37:24'!
initialize
	| interfazInterna |

	interfazInterna := InterfazInterna newConCatalogo: self catalogo
											sistemaDeAutenticacion: self sistemaDeAutenticacion
											merchantProcessor: self merchantProcessor
											yTiempoDeSesion: self tiempoDeSesion.
											
	interfazExterna := InterfazExterna newCon: interfazInterna.
	
	servidor := WebServer reset default.
	
	self addServiceCreateCart.
	self addServiceAddToCart.
	self addServiceListCart.
	self addServiceCheckOutCart! !

!ServidorWeb methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:23:33'!
merchantProcessor

	^ [ :anAmountToDebit :aCreditCard | MercadoPago new debit: anAmountToDebit from: aCreditCard ]! !

!ServidorWeb methodsFor: 'private' stamp: 'S.V. 6/22/2024 20:23:37'!
sistemaDeAutenticacion

	^ [ :usuario :contraseña | OAuthAuthenticationSystem new authenticate: usuario withPassword: contraseña ]! !

!ServidorWeb methodsFor: 'private' stamp: 'S.V. 6/23/2024 17:59:07'!
tiempoDeSesion
	^ TimeUnits minute with: 1! !


!ServidorWeb methodsFor: 'public' stamp: 'S.V. 6/22/2024 20:33:55'!
destruir

	servidor destroy! !


!ServidorWeb methodsFor: 'servicio' stamp: 'S.V. 6/22/2024 20:22:55'!
addServiceAddToCart

	^ self agregarServicio: '/addToCart' conBloque: [ :request |
		interfazExterna agregarAlCarrito: request fields
	]! !

!ServidorWeb methodsFor: 'servicio' stamp: 'S.V. 6/22/2024 20:22:52'!
addServiceCheckOutCart

	^ self agregarServicio: '/checkOutCart' conBloque: [ :request |
		interfazExterna checkOut: request fields
	]! !

!ServidorWeb methodsFor: 'servicio' stamp: 'S.V. 6/22/2024 20:22:57'!
addServiceCreateCart

	^ self agregarServicio: '/createCart' conBloque: [ :request |
		interfazExterna crearCarrito: request fields
	]! !

!ServidorWeb methodsFor: 'servicio' stamp: 'S.V. 6/22/2024 20:22:59'!
addServiceListCart

	^ self agregarServicio: '/listCart' conBloque: [ :request |
		interfazExterna listarCarrito: request fields
	]! !

!ServidorWeb methodsFor: 'servicio' stamp: 'S.V. 6/22/2024 20:23:01'!
agregarServicio: unaRuta conBloque: unBloque

	^ servidor addService: unaRuta action: [ :request |
		| respuesta status body |
	
		respuesta := unBloque value: request.
		status := respuesta at: 'status'.
		body := respuesta at: 'body'.
		request sendResponseCode: status content: body type: 'text/plain; charset=utf8' do: [ :aResponse | ].
	]

	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ServidorWeb class' category: #TusLibros!
ServidorWeb class
	instanceVariableNames: ''!

!ServidorWeb class methodsFor: 'instance creation' stamp: 'S.V. 6/23/2024 17:34:33'!
escucharEnPuerto9000
	^ self new escucharEnPuerto: 9000! !

!ServidorWeb class methodsFor: 'instance creation' stamp: 'S.V. 6/4/2024 19:45:03'!
escucharEnPuerto: unPuerto
	^ self new escucharEnPuerto: unPuerto! !


!classDefinition: #Sesion category: #TusLibros!
Object subclass: #Sesion
	instanceVariableNames: 'valor medidaDeTiempoDeSesion finDeSesion'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sesion methodsFor: 'initialization' stamp: 'S.V. 6/23/2024 18:06:35'!
con: unObjeto conTiempoDeSesion: unaMedidaDeTiempoDeSesion

	valor := unObjeto.
	medidaDeTiempoDeSesion := unaMedidaDeTiempoDeSesion.

	self renovarTiempoDeSesion! !


!Sesion methodsFor: 'private' stamp: 'S.V. 6/23/2024 18:06:22'!
renovarTiempoDeSesion

	finDeSesion := GregorianDateTime now next: medidaDeTiempoDeSesion! !


!Sesion methodsFor: 'public' stamp: 'S.V. 6/23/2024 18:06:28'!
acceder

	self estaExpirada ifTrue: [ self error: self class errorSesionExpirada ].

	self renovarTiempoDeSesion.

	^ valor
	! !

!Sesion methodsFor: 'public' stamp: 'S.V. 6/23/2024 18:29:42'!
estaExpirada

	^ GregorianDateTime now > finDeSesion! !

!Sesion methodsFor: 'public' stamp: 'S.V. 6/23/2024 17:46:07'!
pasarTiempo: unTiempoDeSesionAIncrementar

	finDeSesion := finDeSesion previous: unTiempoDeSesionAIncrementar! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sesion class' category: #TusLibros!
Sesion class
	instanceVariableNames: ''!

!Sesion class methodsFor: 'instance creation' stamp: 'S.V. 6/23/2024 15:17:11'!
newCon: unObjeto conTiempoDeSesion: unaMedidaDeTiempoDeSesion
	^ self new con: unObjeto
			    conTiempoDeSesion: unaMedidaDeTiempoDeSesion! !


!Sesion class methodsFor: 'error' stamp: 'S.V. 6/23/2024 15:52:12'!
errorSesionExpirada
	^ 'Sesion expirada.'! !


!classDefinition: #TarjetaDeCredito category: #TusLibros!
Object subclass: #TarjetaDeCredito
	instanceVariableNames: 'numeroDeTarjeta mesDeAñoDeExpiracion titular'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TarjetaDeCredito methodsFor: 'public' stamp: 'S.V. 6/22/2024 20:35:19'!
estaVencida

	^ mesDeAñoDeExpiracion < GregorianMonthOfYear current
! !

!TarjetaDeCredito methodsFor: 'public' stamp: 'S.V. 6/23/2024 18:21:48'!
number
	^ numeroDeTarjeta copy
	! !


!TarjetaDeCredito methodsFor: 'initialization' stamp: 'S.V. 6/21/2024 17:09:59'!
conNumero: unNumeroDeTarjeta
conMesDeAñoDeExpiracion: unMesDeAñoDeExpiracion
conTitular: unNombreDelTitular

	numeroDeTarjeta := unNumeroDeTarjeta.
	mesDeAñoDeExpiracion := unMesDeAñoDeExpiracion.
	titular := unNombreDelTitular! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TarjetaDeCredito class' category: #TusLibros!
TarjetaDeCredito class
	instanceVariableNames: ''!

!TarjetaDeCredito class methodsFor: 'instance creation' stamp: 'S.V. 6/21/2024 17:10:12'!
newConNumeroDeTarjeta: unNumeroDeTarjeta
conMesDeAñoDeExpiracion: unMesDeAñoDeExpiracion
conTitular: unNombreDelTitular

	^ self new conNumero: unNumeroDeTarjeta
				 conMesDeAñoDeExpiracion: unMesDeAñoDeExpiracion
				 conTitular: unNombreDelTitular! !
!classDefinition: #MercadoPago category: #'TusLibros-ExternalServices'!
Object subclass: #MercadoPago
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-ExternalServices'!

!MercadoPago methodsFor: 'public' stamp: 'LL 11/28/2023 18:26:39'!
debit: anAmountToDebit from: aCreditCard

	"Acá implementaríamos la comunicación con la API de Mercado Pago - Luciano."
	
	aCreditCard number = '1111111111111117' ifTrue: [ self error: 'Stolen card!!' ]! !


!classDefinition: #OAuthAuthenticationSystem category: #'TusLibros-ExternalServices'!
Object subclass: #OAuthAuthenticationSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-ExternalServices'!

!OAuthAuthenticationSystem methodsFor: 'public' stamp: 'S.V. 6/22/2024 20:26:39'!
authenticate: aClientId withPassword: aPassword

	"Acá implementaríamos la comunicación con el sistema externo - Luciano."
	
	(aClientId = 'yenny' and: [ aPassword = 'elAteneo2003' ]) ifFalse: [ self error: 'Invalid credentials' ]! !
