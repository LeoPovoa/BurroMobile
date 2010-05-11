//
//  BurroMobileViewController.m
//  BurroMobile
//
//  Created by Carlos Leonardo Ramos Póvoa on 01/02/10.
//  Copyright LogGeo 2010. All rights reserved.
//

#import "BurroMobileViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation BurroMobileViewController

// Cria os Métodos Set e Get
@synthesize lbStatus;
@synthesize lbServidor;
@synthesize ServerId;
@synthesize btHapax;
@synthesize btFundo;
@synthesize LocationManager;
@synthesize Ponto;

// Métodos

// Acceleration Delegator


// Botão Iniciar envio (HAPAX);
- (IBAction) AcHapax:  (id)sender;
{
    
	NSString *Texto = [NSString alloc];	
	Texto=@"HAPAX";
    lbStatus.text=Texto;
	[Texto release];
	
	if (Botao==-1 || Botao==5 )  { // HAPAX
	  [LocationManager startUpdatingHeading];
	  [LocationManager startUpdatingLocation];  
	  UIImage *Imagem = [UIImage imageNamed:@"PAUSE.gif"];
	  [btHapax setImage:Imagem forState:UIControlStateNormal];
	  btHapax.backgroundColor = [UIColor greenColor];
	  btFundo.backgroundColor = [UIColor greenColor];
	  Botao=0;	
	} 
	
	else if(Botao==0) // Pause
	{
		
		[LocationManager stopUpdatingLocation];	
		[LocationManager stopUpdatingHeading];
		UIImage *Imagem = [UIImage imageNamed:@"REC.gif"];
		[btHapax setImage:Imagem forState:UIControlStateNormal];
		btHapax.backgroundColor = [UIColor redColor];
		btFundo.backgroundColor = [UIColor redColor];
		lbStatus.textColor=[UIColor blackColor];
		Botao=-1;
	}	    
	
}

// QUEBRA ...	

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
	
	static NSInteger ShakeCount;
	static NSDate   *ShakeStart;
	
	NSDate *now =[[NSDate alloc] init];
	NSDate *CheckDate =[[NSDate alloc] initWithTimeInterval:1.5f sinceDate:ShakeStart];
	
	if ([now compare:CheckDate]==NSOrderedDescending || ShakeStart==nil){
	   
		ShakeCount=0;
		[ShakeStart release];
		ShakeStart = [[NSDate alloc] init];
	
	}
	[now release];
	[CheckDate release];
	
	if (fabs(acceleration.x)>2.2 || fabs(acceleration.y)>2.2 || fabs(acceleration.z)>2.2) {
	  
		ShakeCount++;
		if(ShakeCount>4) {
			ShakeCount =0;
			[ShakeStart release];
			ShakeStart = [[NSDate alloc] init];	
			if ((Botao!=5) && (Botao!=-1) && (Contador!=0)){	
			   AudioServicesPlaySystemSound(SomQuebra);
			   [LocationManager stopUpdatingLocation];	
			   [LocationManager stopUpdatingHeading];	
			   [NMEA setString:@"http://www.loggeo.net/burro.aspx?id="];
			   [NMEA appendString: ServerId.text];
			   [NMEA appendString: @"&NMEA=quebra"];
			   [self EnviaPost];
			   UIImage *Imagem = [UIImage imageNamed:@"quebra.gif"];
			   [btHapax setImage:Imagem forState:UIControlStateNormal];
			   btHapax.backgroundColor = [UIColor yellowColor];
			   btFundo.backgroundColor = [UIColor yellowColor];
			   Botao=5;			
			   Quebra=1;	
				
			} //Botao Tipo
			
		} //ShakeCount
	
	} // Acelerar
	
} // Fim		
	
		
	
// Teclado
- (IBAction) DeixarTeclado: (id)sender;
{
	NSString *Texto = [NSString alloc];	
	Texto=@"HAPAX";
    lbStatus.text=Texto;
	[Texto release];
	[sender resignFirstResponder];
}


- (IBAction) CancelarTeclado: (id)sender;
{ 
	NSString *Texto = [NSString alloc];	
	Texto=@"HAPAX";
    lbStatus.text=Texto;
	[Texto release];
	[ServerId resignFirstResponder];	
}

- (IBAction) EscreveTeclado:  (id)sender;
{
	lbStatus.text=ServerId.text;
	lbStatus.textColor=[UIColor blackColor];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


// Destroi os Objetos
- (void)dealloc {
	
    [LocationManager realease];
	[Ponto release];
	[lbStatus release];
	[ServerId release];
	[btHapax  release];
	[btFundo release];
	[lbServidor release];
	[NMEA release];
	[super dealloc];
}

#pragma mark -
#pragma mark LocationManager

- (void)viewDidLoad {
	 
	 Botao=5;
	 Quebra=0;
	 self.LocationManager = [[CLLocationManager alloc] init];
	 LocationManager.delegate=self;
	 LocationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
	 LocationManager.distanceFilter=2; //Filtro Máximo de Distância de 2 metros
	
	 UIAccelerometer *acelera =[UIAccelerometer sharedAccelerometer];
	 acelera.delegate=self;
	 acelera.updateInterval= 1.0f/10.0f;
     
	 // Som
	 NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"]; 
	 AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &SomQuebra);
	
	 NMEA=[[NSMutableString alloc]  init];
	 [super viewDidLoad];
}
		
		
 
// Nova Localização Adquirida

- (void)locationManager:(CLLocationManager *)manager 
		 didUpdateToLocation:(CLLocation *)newLocation 
		 fromLocation:(CLLocation *)oldLocation {
	
if (Ponto == nil) self.Ponto=newLocation;

   //NSString  *PrecisaoText=[[NSString alloc] initWithFormat:@"Precisão:%.1f m", newLocation.horizontalAccuracy];
   // lbPrecisao.text=PrecisaoText;
	
	
if (newLocation.horizontalAccuracy<=100) // Para pegar somente pontos GPS de boa qualidade . .. 
{
	lbStatus.textColor=[UIColor whiteColor];
// Monta String NMEA ==> $GPRMC,180446.18,A,1955.5219,S,04356.0373,W,0.00,0.00,171107,,	
// [NMEA setString:@""]; //teste	
	[NMEA setString:@"http://www.loggeo.net/burro.aspx?id="];
	[NMEA appendString: ServerId.text];
	[NMEA appendString: @"&NMEA=$GPRMC,"];		
	
// Hora do Sinal GPS
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *GpsData;
	GpsData=[[NSDate alloc] init];
	GpsData= newLocation.timestamp; // Hora de Aquisição
// Get hours, minutes, seconds, day, month and year
	NSDateComponents *H = [cal components:NSHourCalendarUnit   fromDate:GpsData];
	NSDateComponents *M = [cal components:NSMinuteCalendarUnit fromDate:GpsData];
	NSDateComponents *S = [cal components:NSSecondCalendarUnit fromDate:GpsData];
	NSDateComponents *Dia = [cal components:NSDayCalendarUnit fromDate:GpsData];
	NSDateComponents *Mes = [cal components:NSMonthCalendarUnit fromDate:GpsData];
	NSDateComponents *Ano = [cal components:NSYearCalendarUnit fromDate:GpsData];
    [NMEA appendFormat:@"%d%d%d.%d",H.hour,M.minute,S.second,S.second];
	
// Caracter de Controle da Qualidade do Ponto GPS
	[NMEA appendString:@",A,"];
	
 //[NMEA setString:@""];
	
// Latitude e Longitude
	double latitude,longitude,latFrac,longFrac;
	static double latAnt, longAnt;
	int Ilat,Ilon;
	
		
	NSString *Equador=[NSString alloc];
	NSString *Meridiano=[NSString alloc];
    if (newLocation.coordinate.latitude>0)  Equador=@"N"; else Equador=@"S"; 
	if (newLocation.coordinate.longitude>0) Meridiano=@"E"; else Meridiano=@"W"; 
    
	latitude=fabs(newLocation.coordinate.latitude);
	longitude=fabs(newLocation.coordinate.longitude);
	
	Ilat=(int)latitude;
	Ilon=(int)longitude;
	latFrac=(float)latitude-Ilat;
	longFrac=(float)longitude-Ilon;
    latFrac=latFrac*60;
	longFrac=longFrac*60;
	if (latFrac>=10)[NMEA appendFormat:@"%d%f,",Ilat, latFrac]; else [NMEA appendFormat:@"%d0%f,",Ilat, latFrac]; 
	[NMEA appendString:Equador];
	if (longFrac>=10) [NMEA appendFormat:@",%d%f,",Ilon, longFrac]; else [NMEA appendFormat:@",%d0%f,",Ilon, longFrac];
	[NMEA appendString:Meridiano];
	
// Velocidade, no Iphone m/s NMEA = knots ==> Milhas Nauticas por Segundo
    double velocidade;
	if ([newLocation speed]<0) velocidade=0;  else  velocidade=newLocation.speed*1.942615;
	[NMEA appendFormat:@",%.2f",velocidade];
	
// Azimute
    double Azimute;
	if ([newLocation course ]<0) Azimute=0;  else  Azimute=newLocation.course;
	[NMEA appendFormat:@",%.2f",Azimute];	

// Dia Mes e ano e fechar String	
	int Ano2;
	Ano2=Ano.year-2000;
	if (Mes.month<10 && Dia.day<10) [NMEA appendFormat:@",0%d0%d%d,,",Dia.day,Mes.month,Ano2]; 
	else if (Dia.day<10 && Mes.month>=10) [NMEA appendFormat:@",0%d%d%d,,",Dia.day,Mes.month,Ano2]; 
	else if (Mes.month<10 && Dia.day>=10) [NMEA appendFormat:@",%d0%d%d,,",Dia.day,Mes.month,Ano2]; 
	else [NMEA appendFormat:@",%d%d%d,,",Dia.day,Mes.month,Ano2];		
			
	
	// Verifica o Ponto de Quebra ...
	if (Quebra==1) {
		
		if (newLocation.coordinate.latitude!=latAnt && newLocation.coordinate.longitude!=longAnt)
		   {
			  [self EnviaPost];
			  Quebra=0;
	       }
   }
	// Grava no Buffer
	else 
	{
		[self EnviaPost];
		Quebra=0;
	}	
	
	latAnt=newLocation.coordinate.latitude;
	longAnt=newLocation.coordinate.longitude;
	
	
// Atualiza Tela	
	//NSString  *LatText=[[NSString alloc] initWithFormat:@"Lat:%g°", newLocation.coordinate.latitude];
    //lbLat.text=LatText;
	//NSString  *LongText=[[NSString alloc] initWithFormat:@"Lon:%g°", newLocation.coordinate.longitude];
    //lbLong.text=LongText;
	//NSString  *AziText=[[NSString alloc] initWithFormat:@"Azimute:%.2f° N", Azimute];
    //lbAzimute.text=AziText;
	//NSString  *VelText=[[NSString alloc] initWithFormat:@"Velocidade:%g m/s", newLocation.speed];
    //lbVelocidade.text=VelText;
	
	
// Apaga Objetos	
	[Equador release];
	[Meridiano release];
	[cal release];
} else {
		  lbStatus.textColor=[UIColor blackColor];
		}
// Precisao da Localizacao
	//[PrecisaoText release];
}


//Deu Merda
- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error {
    
    NSString *errorType = (error.code == kCLErrorDenied) ? 
    @"Access Denied" : @"Unknown Error";
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Erro no GPS do Iphone. Fudeu!!!" 
                          message:errorType 
                          delegate:nil 
                          cancelButtonTitle:@"Ok" 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}

//Envia o Post
-(void) EnviaPost{
	
// Teste 
	//[NMEA appendString:@"&NMEA=$GPRMC,244718.44,A,2545.7135,S,04420.4112,W,0.00,0.00,051007,,A"];	
	//TESTE url=@"http://www.loggeo.net/burro.aspx?id=i2.dat&NMEA=$GPRMC,244718.44,A,2545.7135,S,04420.4112,W,0.00,0.00,051007,,A";

	//lbStatus.text =NMEA;
	
// Seta a Conexão para POST
	NSURL *theUrl =[NSURL URLWithString:NMEA]; 
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theUrl];
    [theRequest setHTTPMethod:@"POST"];
	[theRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
    
	// Simbolo de Atividade de Rede Ativo
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
	
	NSURLConnection *Conexao =[[ NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (!Conexao)
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Erro ao Enviar NMEA" 
							  message:"@Erro de Rede"
							  delegate:nil 
							  cancelButtonTitle:@"Ok" 
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		
	} else { //Atualiza Status do Servidor
			++Contador;
		     NSString *Texto = [[NSString alloc] initWithFormat:@"#%d",Contador];	
			 lbServidor.text=Texto;
		     if (fmod(Contador,2)==0) lbServidor.textColor=[UIColor blackColor];
                 else lbServidor.textColor=[UIColor blueColor];
		      
	         }

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
	
	//Delete os Objetos de Rede
	[theUrl release];
	
	
}


/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */



@end
