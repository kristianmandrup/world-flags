module WorldFlags
	module Languages
		class << self		
 			attr_writer :en

			def en
				@en ||= {
					:ar => 'Argentinian Spanish',
					:br => 'Brazilian Portuguese',
					:po => 'Portuguese',
					:gr => 'Greek',
					:gb => 'British English',
					:us => 'US English',				
					:es => 'Spanish',
					:it => 'Italian',
					:nl => 'Dutch',
					:de => 'German',
					:dk => 'Danish',
					:se => 'Swedish',
					:no => 'Norwegian',
					:fi => 'Finnish'
				}
			end
		end
	end
end