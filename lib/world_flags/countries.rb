module WorldFlags
	module Countries
		class << self		
 			attr_writer :en

			def en
				{
					:ar => 'Argentina',
					:br => 'Brazil',
					:gb => 'Great Britain',
					:us => 'United States',				
					:es => 'Spain',
					:gr => 'Greece',
					:it => 'Italy',
					:nl => 'Netherlands',
					:de => 'Germany',
					:dk => 'Denmark',
					:sv => 'Sweden',
					:no => 'Norway',
					:nb => 'Norway',
					:fi => 'Finland'
				}
			end

			def da
				{
					:gb => 'England',
					:us => 'USA',				
					:es => 'Spanien',
					:de => 'Tyskland',
					:dk => 'Danmark',
					:sv => 'Sverige',
					:no => 'Norge',
					:nb => 'Norge',
				}
			end
			alias_method :dk, :da			

			def se
				{
					:gb => 'England',
					:us => 'USA',				
					:es => 'Spanien',
					:de => 'Tyskland',
					:dk => 'Danmark',
					:sv => 'Sverige',
					:no => 'Norge',
					:nb => 'Norge',
				}
			end

			def no
				{
					:gb => 'England',
					:us => 'USA',				
					:es => 'Spanien',
					:de => 'Tyskland',
					:dk => 'Danmark',
					:se => 'Sverige',
					:no => 'Norge',					
					:nb => 'Norge',
				}
			end
		end
	end
end