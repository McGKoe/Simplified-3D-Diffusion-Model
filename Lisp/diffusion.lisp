#!/usr/bin/sbcl --script



(progn

	(defvar maxsize)

	(defvar answer)
	

	;; takes in the nuber of divisions in the room
	(princ "Number of divisions: ")
	(terpri)
	(setf maxsize (read))

	(princ "With partition? (y/n) ")
	(terpri)
	(setf answer (read-char))



	(defvar cube)

	;; defines the space and sets the intial value to 0
	(setf cube (make-array (list maxsize maxsize maxsize) :initial-element 0))


	(defvar diffusion_coef 0.175)	
	(defvar room_dimen 5.0)		; room is 5 metes in length
	(defvar molecule_speed 250.0)	; based on 110 g/mol gas at RT
	(defvar timestep)

	(setf timestep (/ (/ room_dimen molecule_speed) maxsize))

	(defvar distance_bw)

	(setf distance_bw (/ room_dimen maxsize))

	(defvar DTerm (/ (* diffusion_coef timestep) (* distance_bw distance_bw)))





	;;initialize first cell
	(setf (aref cube 0 0 0) 1.0E+21)


	(defvar keeptime 0.0) ;keeps track of accumulated system time
	(defvar ratioo 0.0)	;; ratio of minimum concentration to maximum concentration

	(defvar sumval 0.0)
	(defvar maxval (aref cube 0 0 0))
	(defvar minval (aref cube 0 0 0))


	(defvar change)


	(if (char-equal answer #\n)
		(progn

		(loop while (< ratioo 0.99)
			do

				(loop for i from 0 below maxsize do
					(loop for j from 0 below maxsize do
						(loop for k from 0 below maxsize do
							(loop for l from 0 below maxsize do
								(loop for m from 0 below maxsize do
									(loop for n from 0 below maxsize do
								
										(if (and (= i l) (and (= j m) (= k (+ n 1))))
										(progn	
											(setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))
	
											(setf (aref cube i j k) (- (aref cube i j k) change))
		
											(setf (aref cube l m n) (+ (aref cube l m n) change))
										)
										
										)
										(if (and (= i l) (and (= j m) (= k (- n 1))))
                                                        	                (progn
                                                                	               (setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))

                                                                        	        (setf (aref cube i j k) (- (aref cube i j k) change))

                                                                                	(setf (aref cube l m n) (+ (aref cube l m n) change))
                                                                       		)
                                                                                
                                                                        	)
										(if (and (= i l) (and (= k n) (= j (+ m 1))))
                                                                        	(progn
											(setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))

                                                                                	(setf (aref cube i j k) (- (aref cube i j k) change))

                                                                                	(setf (aref cube l m n) (+ (aref cube l m n) change))
                                                                        	)
                                                                                
                                                                        	)
										(if (and (= i l) (and (= k n) (= j (- m 1))))
                                                                	        (progn
											(setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))

                                                        	                        (setf (aref cube i j k) (- (aref cube i j k) change))
	
        	                                                                        (setf (aref cube l m n) (+ (aref cube l m n) change))
                	                                                        )
                        	                                                        
                                	                                        )
										(if (and (= j m) (and (= k n) (= i (+ l 1))))
                                                	                        (progn
											(setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))

                                                                	                (setf (aref cube i j k) (- (aref cube i j k) change))

                                                                        	        (setf (aref cube l m n) (+ (aref cube l m n) change))
                                                                        	)
                                                                                
                                                                        	)
										(if (and (= k n) (and (= j m) (= i (- l 1))))
                                	                                        (progn
											(setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))

                         	                                                       (setf (aref cube i j k) (- (aref cube i j k) change))

                                                	                                (setf (aref cube l m n) (+ (aref cube l m n) change))
                                                        	                )
                                                                                
                                                                	        )

				





									)
								)
							)
						)
					)
				)

			;; increment time
			(setf keeptime (+ keeptime timestep))
		

			(setf sumval 0.0)
			(setf maxval (aref cube 0 0 0))
			(setf minval (aref cube 0 0 0))

			;;find min and max of cube
			;;
			(loop for i from 0 below maxsize do
				(loop for j from 0 below maxsize do
					(loop for k from 0 below maxsize do
				
					(setf maxval (max (aref cube i j k) maxval))
					(setf minval (min (aref cube i j k) minval))


					(setf sumval (+ sumval (aref cube i j k)))



					)
				)
			)

			(setf ratioo (/ minval maxval))

			(princ "Ratio:" )
			(write ratioo)
			(print " time ")
			(princ keeptime)

			(print (aref cube 0 0 0))
			(princ " ")
			(princ (aref cube (- maxsize 1) 0 0))
        	        (princ " ")
                	(princ (aref cube (- maxsize 1) (- maxsize 1) 0))
                	(princ " ")
                	(princ (aref cube (- maxsize 1) (- maxsize 1) (- maxsize 1)))
                	(princ " ")
			(princ sumval)
			(terpri)
		


	)
	)

	(progn 
		(defvar bitmap)
	

		;;initializes the map that will hold the partition
		(setf bitmap (make-array (list (+ 2 maxsize) (+ 2 maxsize) (+ 2 maxsize)) :initial-element 1))


		;;fills array with ones except for the partition
		(loop for i from 0 below (+ 2 maxsize) do
			(write i)
			(loop for j from 0 below (+ 2 maxsize) do
				(loop for k from 0 below (+ 2 maxsize) do
				(if (= (floor (/ (+ 2 maxsize) 2)) i)
					(progn
						(if (>= j (floor (+ 1 (* (+ 2 maxsize) .25))))
							(setf (aref bitmap i j k) 0)
						;	(setf (aref bitmap i j k) 1)


						)
					)
				)	

				(if ( = 0 i)
					(setf (aref bitmap i j k) 0)

				)
			
				(if ( = 0 j)
					(setf (aref bitmap i j k) 0)

				)

				(if ( = 0 k)
					(setf (aref bitmap i j k) 0)

				)
	
				(if ( = 0 i)
					(setf (aref bitmap i j k) 0)

				)


				(if ( = (+ 1 maxsize) i)
					(setf (aref bitmap i j k) 0)

				)
				(if ( = (+ 1 maxsize) j)
					(setf (aref bitmap i j k) 0)

				)
				(if ( = (+ 1 maxsize) k)
					(setf (aref bitmap i j k) 0)

				)
		
				
				)
			)
		)





		(loop while (< ratioo 0.99)
			do

				(loop for i from 0 below maxsize do
					(loop for j from 0 below maxsize do
						(loop for k from 0 below maxsize do
							(loop for l from 0 below maxsize do
								(loop for m from 0 below maxsize do
									(loop for n from 0 below maxsize do

									(if (and (= (aref bitmap (+ 1 i) (+ 1 j) (+ 1 k)) 1) (= (aref bitmap (+ 1 l) (+ 1 m) (+ 1 n)) 1))							
										(progn
										(if (and (= i l) (and (= j m) (= k (+ n 1))))
										(progn	
											(setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))
	
											(setf (aref cube i j k) (- (aref cube i j k) change))
		
											(setf (aref cube l m n) (+ (aref cube l m n) change))
										)
										
										)
										(if (and (= i l) (and (= j m) (= k (- n 1))))
                                                        	                (progn
                                                                	               (setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))

                                                                        	        (setf (aref cube i j k) (- (aref cube i j k) change))

                                                                                	(setf (aref cube l m n) (+ (aref cube l m n) change))
                                                                       		)
                                                                                
                                                                        	)
										(if (and (= i l) (and (= k n) (= j (+ m 1))))
                                                                        	(progn
											(setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))

                                                                                	(setf (aref cube i j k) (- (aref cube i j k) change))

                                                                                	(setf (aref cube l m n) (+ (aref cube l m n) change))
                                                                        	)
                                                                                
                                                                        	)
										(if (and (= i l) (and (= k n) (= j (- m 1))))
                                                                	        (progn
											(setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))

                                                        	                        (setf (aref cube i j k) (- (aref cube i j k) change))
	
        	                                                                        (setf (aref cube l m n) (+ (aref cube l m n) change))
                	                                                        )
                        	                                                        
                                	                                        )
										(if (and (= j m) (and (= k n) (= i (+ l 1))))
                                                	                        (progn
											(setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))

                                                                	                (setf (aref cube i j k) (- (aref cube i j k) change))

                                                                        	        (setf (aref cube l m n) (+ (aref cube l m n) change))
                                                                        	)
                                                                                
                                                                        	)
										(if (and (= k n) (and (= j m) (= i (- l 1))))
                                	                                        (progn
											(setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))

                         	                                                       (setf (aref cube i j k) (- (aref cube i j k) change))

                                                	                                (setf (aref cube l m n) (+ (aref cube l m n) change))
                                                        	                )
                                                                                
                                                                	        )

										);;end of progn
										)

				





									)
								)
							)
						)
					)
				)

			(setf keeptime (+ keeptime timestep))
		

			(setf sumval 0.0)
			(setf maxval (aref cube 0 0 0))
			(setf minval (aref cube 0 0 0))


			;; find min and max of cube
			(loop for i from 0 below maxsize do
				(loop for j from 0 below maxsize do
					(loop for k from 0 below maxsize do
				
					(if (= (aref bitmap (+ 1 i) (+ 1 j) (+ 1 k)) 1)
						(progn	
						(setf maxval (max (aref cube i j k) maxval))
						(setf minval (min (aref cube i j k) minval))


						(setf sumval (+ sumval (aref cube i j k)))
						)
					)

					)
				)
			)

			(setf ratioo (/ minval maxval))

			(princ "Ratio:" )
			(write ratioo)
			(print " time ")
			(princ keeptime)

			(print (aref cube 0 0 0))
			(princ " ")
			(princ (aref cube (- maxsize 1) 0 0))
        	        (princ " ")
                	(princ (aref cube (- maxsize 1) (- maxsize 1) 0))
                	(princ " ")
                	(princ (aref cube (- maxsize 1) (- maxsize 1) (- maxsize 1)))
                	(princ " ")
			(princ sumval)
			(terpri)
		

		)
	)

)

	(print "Box equilibrated in ")
	(princ keeptime)
	(princ " seconds of simulated time")
			

)
