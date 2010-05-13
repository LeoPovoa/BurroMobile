//
//  BurroMobileViewController.h
//  BurroMobile
//
//  Created by Carlos Leonardo Ramos Póvoa on 01/02/10.
//  Copyright HAPAX 2010. All rights reserved.
//

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program. (GPL_LICENSE.txt) If not, see <http://www.gnu.org/licenses/>



#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface BurroMobileViewController : UIViewController <CLLocationManagerDelegate, UIAccelerometerDelegate> {

// CoreLocation
	CLLocationManager *LocationManager;
	CLLocation        *Ponto;

// Outros	
	NSMutableString   *NMEA;
	int Contador;
	int Botao;  // -1=Hapax 1=Pausa 2=Quebra 
	int Quebra; // 0=Inativo 1=Ativo
	
// Som
	SystemSoundID SomQuebra;
	
	
// Interface IB	
	IBOutlet UILabel *lbStatus;
	IBOutlet UITextField *ServerId;
	IBOutlet UILabel  *lbServidor;
	IBOutlet UIButton *btFundo;
	IBOutlet UIButton *btHapax;
	
}

// Labels
@property (retain, nonatomic) UILabel *lbStatus;
@property (retain, nonatomic) UILabel *lbServidor;


// Caixas de texto
@property (retain,nonatomic)  UITextField *ServerId;


// Botoes
@property (retain,nonatomic)  UIButton *btHapax;
@property (retain,nonatomic)  UIButton *btFundo;


// Location
@property (retain, nonatomic) CLLocationManager *LocationManager;
@property (retain, nonatomic) CLLocation        *Ponto;


// Métodos
- (IBAction) AcHapax:         (id)sender;
- (IBAction) DeixarTeclado:   (id)sender;
- (IBAction) CancelarTeclado: (id)sender; 
- (IBAction) EscreveTeclado:  (id)sender;
- (void)     EnviaPost;

@end

