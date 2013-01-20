Maid.rules do

  rule 'Update yourself' do
    `cd ~/.maid && git pull`
  end

  rule 'Trash disk images' do
    trash(dir('~/Downloads/*.dmg'))
  end

  rule 'Mac OS X applications in zip files' do
    found = dir('~/Downloads/*.zip').select do |path|
      zipfile_contents(path).any? { |c| c.match(/\.app[\/]*$/) }
    end

    trash(found)
  end

  rule 'Move applications to Applications directory' do
    dir('~/Downloads/*.app').each{ |path| move(path, '/Applications') }
  end

  rule 'Screenshots' do
    screen_shot_dir = '~/Documents/Screenshots/'
    mkdir(screen_shot_dir)
    dir('~/Desktop/Screen Shot *').each do |path|
      move(path, screen_shot_dir)
    end
  end

  rule 'Old files downloaded while developing' do
    dir('~/Downloads/*').each do |path|
      if downloaded_from(path).any? { |u| u.match('http://localhost') } && 1.day.since?(accessed_at(path))
        trash(path)
      end
    end
  end

  rule 'Organize Downloads' do
    types = { 'public.image' => 'Images', 'com.adobe.pdf' => 'PDFs', 'public.archive' => 'Archives', 'public.audio' => 'Audio' }
    types.each do |type, sub_dir|
      organized_dir = "~/Downloads/#{ sub_dir }"
      mkdir(organized_dir)
      move(filter_by_content_type(dir('~/Downloads/*'), type), organized_dir)
    end
  end

end