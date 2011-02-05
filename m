From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: ANNOUNCE: TimeBrowse 0.1 released
Date: Sat, 05 Feb 2011 15:58:12 +0900 (JST)
Message-ID: <20110205.155812.119546877.ryusuke@osrg.net>
References: <874o8kue08.wl%jir@sekiba.com>
	<AANLkTinVaRJn4gfj8HousZ3eUhOee3C-U51nMAs6ZLUA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinVaRJn4gfj8HousZ3eUhOee3C-U51nMAs6ZLUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 5 Feb 2011 01:48:43 +0900, Ryusuke Konishi wrote:
> - The following error happened when I ran the snapshot manager.
>   My python version is 2.7.1+ and yaml version is 3.09
> 
>  $ sudo ./nilfs2_ss_manager
> 
> Traceback (most recent call last):
>   File "./nilfs2_ss_manager", line 141, in <module>
>     conf = yaml.safe_load(open(conffile))
>   File "/usr/lib/python2.7/dist-packages/yaml/__init__.py", line 75,
> in safe_load
>     return load(stream, SafeLoader)
>   File "/usr/lib/python2.7/dist-packages/yaml/__init__.py", line 58, in load
>     return loader.get_single_data()
>   File "/usr/lib/python2.7/dist-packages/yaml/constructor.py", line
> 42, in get_single_data
>     node = self.get_single_node()
>   File "/usr/lib/python2.7/dist-packages/yaml/composer.py", line 39,
> in get_single_node
>     if not self.check_event(StreamEndEvent):
>   File "/usr/lib/python2.7/dist-packages/yaml/parser.py", line 93, in
> check_event
>     self.current_event = self.state()
>   File "/usr/lib/python2.7/dist-packages/yaml/parser.py", line 169, in
> parse_document_start
>     self.peek_token().start_mark)
> yaml.parser.ParserError: expected '<document start>', but found
> '<block mapping start>'
>   in "/etc/nilfs_ss.conf", line 14, column 1

This turned out to be my mistake.

I forgot to comment out the "devices:" line in /etc/nilfs_ss.conf as
below.  Sorry.

 #devices:
    /dev/sda8 : /nilfs

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
