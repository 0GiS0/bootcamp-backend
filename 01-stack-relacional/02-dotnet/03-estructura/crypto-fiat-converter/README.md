# crypto-fiat-conversion

Esta librer�a expone funcionalidad para convertir moneda crypto en moneda fiat.

Para ello utiliza una base de datos interna con el tipo de cambio actual. Esta base de datos interna se actualiza, por ahora, manualmente. En el futuro estar� actualizada en todo momento.

## C�mo utilizar
Se instancia `Converter` y se llama al m�todo
```
var result = converter.ConvertToEur("BTC", 5.10);
```
El resultado ser� un objeto de tipo `ConversionResult` que contiene el c�digo de la criptomoneda, la fecha del cambio actual utilizado, y la cantidad total en EUR para la cantidad especificada.

Es importante tener en cuenta que `Converter` tiene una dependencia a `IPriceDatabase`, y que la instancia de `IPriceDatabase` debe ser �nica si se utiliza la implementaci�n `InMemoryPriceDatabase`.