Pod::Spec.new do |s|

    s.name = 'LGDrawer'
    s.version = '1.0.0'
    s.platform = :ios, '6.0'
    s.license = 'MIT'
    s.homepage = 'https://github.com/Friend-LGA/LGDrawer'
    s.author = { 'Grigory Lutkov' => 'Friend.LGA@gmail.com' }
    s.source = { :git => 'https://github.com/Friend-LGA/LGDrawer.git', :tag => s.version }
    s.summary = 'iOS helper draws UIImages programmatically'
    s.description = 'iOS helper draws UIImages programmatically. '                      \
                    'It contains collection of different images like '                  \
                    'rectangle, triangle, ellipse, plus, minus, cross, '                \
                    'line, tick, arrow, heart, star and others. '                       \
                    'You can customize a lot of parameters like '                       \
                    'size of image area, size of image, background color, '             \
                    'fill color, stroke type and color, rotation, shadows and others. ' \
                    'Also you can combine different images into one image.'

    s.requires_arc = true

    s.source_files = 'LGDrawer/*.{h,m}'

end
