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
					:se => 'Sweden',
					:no => 'Norway',
					:fi => 'Finland'
				}
			end
		end
	end
end