----------------------------------- Title ----------------------------------

Chemical and Modelling Evaluation of Five Coagulants/Flocculants for Clarifying and Recovering Nutrients from Liquid Dairy Manure (Australia)

----------------------------------- Authors ----------------------------------

José A. D. López-Coronado, Sharon R. Aarons, Edward Nagul, Michael W. Heaven, Khageswor Giri, Joe L. Jacobs

----------------------------------- Date ----------------------------------

29/01/2026

----------------------------------- Files ----------------------------------

Lopez_coagulation_JWREUSE.csv	R dataset

----------------------------------- Variables -------------------------------

coagulant		Name of the coagulant or flocculant
round			Manure batch number used to carry out the jar tests
date			Date when the jar test was carried out
sample		Sample number
dm_real		Dry matter of the diluted manure as per analysis
dm_expected		Dry matter of the diluted manure as expected
dose			Dose in mg per litre of diluted manure
volume		Volume in mL of the diluted coagulant
ntu			Final turbidity
efficiency		Turbidity removal efficiency (Initial - Final)/(Initial)
		        	Where Initial turbidity is at dose = 0, in that round
removal			Turbidity removal (Initial - Final)
supernatant_ph		pH of the clarified liquid after centrifugation
supernatant_ec		EC in uS/cm of the clarified liquid after centrifugation
subnatant_proportion	(mass sludge)/(mass effluent after coagulation)
				              Mass of effluent is not (effluent) as there are small losses due to decantation
subnatant_perc_dm	Dry matter percentage in the sludge
subnatant_ph		pH of the sludge after centrifugation
subnatant_ec		EC in uS/cm of the sludge after centrifugation
subnatant_gr_dm	DM removal from the sample (subnatant)*(subnatant_perc_dm)
dm_to_subnatant	DM removed = (subnatant_gr_dm)/(dm_input_corrected)
ph_inisup		pH of the clarified liquid at dose = 0 in that round
ph_inisub		pH of the sludge at dose = 0 in that round
ec_inisub		EC in uS/cm of the sludge at dose = 0 in that round
ec_inisup		EC in uS/cm of the liquid at dose = 0 in that round
turb_ini		Turbidity of the dilute manure's supernatant after centrifugation at dose = 0 in that round
effluent		Volume in mL of the diluted manure used in a jar test
subnatant_gr_dm	1000	DM removal per Litre of effluent
		                	Mass of sludge in grams * DM % extrapolated to 1000 mL
                			(1000*subnatant_gr_dm)/(effluent)
dose_mg		Dose in mg in DM basis
dm_si			Dry matter separation index = (subnatant_gr_dm)/(dm_input_corrected)
water_ml		Volume of water in mL used for jar test
supernatant		mass of supernatant (clarified liquid) in grams 
subnatant		mass of sludge (treated effluent) in grams
vol_input_corrected	Corrected volume of (effluent+water_mL+volume) in mL substracting decantation loses =(supernatant)+(subnatant)
dm_input_corrected	Corrected input mass of DM in grams (effluent*dm_real)+(dose_mg/1000)
treatment		Same as coagulant variable but recognizes dose = 0 as	the control variable
dm_realgl		Dry matter in the manure batch control sample (g/L)
