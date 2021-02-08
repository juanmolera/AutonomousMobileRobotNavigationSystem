<h3>Sistema de navegación para un robot autónomo móvil</h3>
El código almacenado en este repositorio simula y permite la navegación de un robot móvil de forma autónoma. Para ello se ha creado un entorno virtual XML para la interfaz experimental Apolo. Es posible establecer una ruta para que el robot patrulle el mapa de forma cíclica o definir misiones temporales a partir de objetivos puntuales. La navegación del robot es reactiva. El planificador de trayectorias cuenta con un mapa del entorno precargado a partir del cual se hace la planificación offline. La ruta diseñada por el planificador se basa en el diagrama de Voronoi del entorno. En el momento en que el robot detecta un obstáculo inesperado que no le permite seguir la ruta offline establecida, recalcula la trayectoria de forma online paras esquivar el obstáculo. <br/>

Representación del robot móvil: <br />
<img src="images/warden.png" width="500">

<br/>
Mapa del entorno: <br />
<img src="images/MapaOcupacion.png" width="500">

<br/>
Trayectoria offline basada en Voronoi: <br />
<img src="images/GrafoFiltradoVoronoi.png" width="500">

**Ejemplos de navegación del robot:** <br />
-Vuelta de reconocimiento con obstáculos inesperados: <br />
https://www.youtube.com/watch?v=N3qLEpVvDxs&t=6s <br />

-Recorrido sin obstáculos inesperados: <br />
https://www.youtube.com/watch?v=YiZZcJ9YF4U <br />

-Pasillo estrecho: <br />
https://www.youtube.com/watch?v=zwjWW0sZss8 <br />
