PImage imgTipo, imgTransicao = createImage(600, 600, HSB); //Imagens.

int contFiltro, t, tipo, velocidade;              //Contadores.
boolean play = true, transicao = true;            //Controle de transições.
boolean transiFiltro = false, filtro = false;     //Controle de filtros.
float r, g, b, cinza;                             //Escalas de cor.
color img, corOriginal, corFinal;

void setup() {
  size(600, 600);
  colorMode(RGB);
  background(20);

  velocidade = 5;        //Velocidade de transição.
  t = 0;                 //Contador ScanLine.
  tipo = 1;              //Número que define qual imagem será mostrada.
  contFiltro = 0;        //Contador que orienta a ativação do loop dos filtros.
}

void draw() {
  int l = width + velocidade;
  int a = height + velocidade;

  if (play == true) {    //Condição para início atrelada à booleana "play" que é alternada pela tecla 'a'.
    contFiltro++;
    t += velocidade;

    if (t % l/velocidade == 0) {    //Sempre que o resto da divisão entre a largura da tela e a velocidade de transição for 0:
      transicao = !transicao;       //Aternar a booleana de transição.
      filtro = !filtro;             //Aternar a booleana de filtro.
      tipo++;                       //Incrementa o número seletor de imagem
      t = 1;                        //Reinicia o scanline.
    }

    if (tipo == 1) {                //Condições para seleção do tipo da imagem de acordo com o valor da variável "tipo".
      imgTipo = loadImage("computacao.jpg");
    } 
    if (tipo == 2) {
      imgTipo = loadImage("design.jpg");
    } 
    if (tipo == 3) {
      imgTipo = loadImage("smd.jpg");
    }  
    if (tipo == 4) {
      tipo = tipo - 3;
    }

    proximaImagem(t, l, a); //             //Ativação das transições simples. A função é ligada ao contador scanline "t".
    if (contFiltro >= l/velocidade * 3) {  //Condição para ativação dos filtros. (Valor do contador maior ou igual a três vezes a largura da tela dividido pela velocidade do scanline).
      filtros(l, a);
    }

    image(imgTransicao, 0, 0);             //Ativação da imagem resultante nas funções acima.
    println("Scanline: "+t, " | Imagem Tipo: "+tipo, " | Transição T=Horizontal / F=Vertical: "+transicao, "| Filtro T=Cinza / F=Negativo: "+filtro);
  }
}

void keyPressed() {
  if (key == 'a' || key == 'A') {          //Início ou pausa do processo ao alternar a booleanta "play" pressionando a tecla A, maiúscula ou minúscula.
    play = !play;
  }
}

void proximaImagem(int t, int l, int a) {

  for (int x = 0; x < l; x++) {
    for (int y = 0; y < a; y++) {

      if (transicao == true) {              //Transição horizontal.
        img = imgTipo.get(x % t, y);
        imgTransicao.set(x % t, y, img);
      } else if (transicao == false) {      //Transição vertical.
        img = imgTipo.get(x, y % t);
        imgTransicao.set(x, y % t, img);
      }
    }
  }
}

void filtros(int l, int a) {   

  for (int x = 0; x < l; x++) {
    for (int y = 0; y < a; y++) {

      if (transicao == true) {                  //Transição horizontal.
        corOriginal = imgTipo.get(x % t, y);
      } else if (transicao == false) {          //Transição vertical.
        corOriginal = imgTipo.get(x, y % t);
      }

      r = red(corOriginal);
      g = green(corOriginal);
      b = blue(corOriginal);

      if (filtro == true) {                    //Filtro cinza.
        cinza = (r + g + b);
        corFinal = color(cinza);
      } else if (filtro == false) {            //Filtro negativo.
        corFinal = color(255-r, 255-g, 255-b);
      }

      if (transicao == true) {                 //Transição horizontal.
        imgTransicao.set(x % t, y, corFinal);
      } else if (transicao == false) {         //Transição vertical.
        imgTransicao.set(x, y % t, corFinal);
      }
    }
  }
}
