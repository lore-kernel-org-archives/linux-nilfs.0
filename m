From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: ANNOUNCE: TimeBrowse 0.1 released
Date: Sat, 5 Feb 2011 01:48:43 +0900
Message-ID: <AANLkTinVaRJn4gfj8HousZ3eUhOee3C-U51nMAs6ZLUA@mail.gmail.com>
References: <874o8kue08.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=OjKG7WguJsAcE6SDxV4O9whGOkfRB5Hnha5ZT2Nh8dM=;
        b=YZ/pJfuDryBzzJKCAOsvsOPRycOuJiwh2vrq92VlN8/1GbY8E/9HcBj1wRUoJX5Zo6
         qE+z4DwhHg4LVeoX1S/NLna1HrCjOGY7i5EGZfvsIvZySLBsNypOhpH+8iQ6k5CB88+A
         fdPV4tNSTildFXQ02GUGwlrXvHgQOiawKJqnI=
In-Reply-To: <874o8kue08.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

2011/2/4 Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>:
> Hi!
>
> I'm pleased to announce the release of "TimeBrowse".
> http://timebrowse.sourceforge.net/
>
> TimeBrowse is a set of programs that enable Windows VSS like
> view in Nautilus PropertyPage against NILFS snapshots.
>
> There are two parts of programs in TimeBrowse, one is Nautilus Extens=
ion
> to browse history of specific file in NILFS volume and snapshots.
> The other is a daemon process which watches NILFS volumes.
>
> The extension scans mtab and find active NILFS volume and snapshot mo=
unts.
> If the file is in the active NILFS volume, it tries to find the snaps=
hot
> mounts of the volume. =A0If there are snapshot mounts, find the speci=
fied
> file and list the history of the file based on different modified tim=
e.
>
> The daemon scans checkpoints at interval of short period.
> When new checkpoints are created, it turns checkpoints to snapshots
> and mounts the snapshots to specified directory automatically.
>
> I'm thinking to make them communicate via dbus in future, like for re=
moving
> snapshots from property view. =A0However those programs are completel=
y
> independent from others so far, so you can use either one of them.
>
> This is still pre-alpha version.
> It won't hurt your system but also may not so useful yet.
>
> Any kind of feedbacks are welcome!
>
> enjoy!
> --
> Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Great!

This sounds like giving what the current our project is lacking.

The followings are comments that I noticed for the moment:

- There is a name mismatch between nilfs2_ss.conf and nilfs_ss.conf;
  nilfs2_ss_manager wanted nilfs_ss.conf as its default configuration f=
ile,
  but nilfs2_ss.conf is provided in the package.

  I personally think "nilfs" is preferable to "nilfs2" whenever it actu=
ally
  doesn't depend on the filesystem version such as mount or disk utilit=
ies.

- The following error happened when I ran the snapshot manager.
  My python version is 2.7.1+ and yaml version is 3.09

 $ sudo ./nilfs2_ss_manager

Traceback (most recent call last):
  File "./nilfs2_ss_manager", line 141, in <module>
    conf =3D yaml.safe_load(open(conffile))
  File "/usr/lib/python2.7/dist-packages/yaml/__init__.py", line 75,
in safe_load
    return load(stream, SafeLoader)
  File "/usr/lib/python2.7/dist-packages/yaml/__init__.py", line 58, in=
 load
    return loader.get_single_data()
  File "/usr/lib/python2.7/dist-packages/yaml/constructor.py", line
42, in get_single_data
    node =3D self.get_single_node()
  File "/usr/lib/python2.7/dist-packages/yaml/composer.py", line 39,
in get_single_node
    if not self.check_event(StreamEndEvent):
  File "/usr/lib/python2.7/dist-packages/yaml/parser.py", line 93, in
check_event
    self.current_event =3D self.state()
  File "/usr/lib/python2.7/dist-packages/yaml/parser.py", line 169, in
parse_document_start
    self.peek_token().start_mark)
yaml.parser.ParserError: expected '<document start>', but found
'<block mapping start>'
  in "/etc/nilfs_ss.conf", line 14, column 1

- I cloned the following git tree instead of downloading the tar ball.

  git://timebrowse.git.sourceforge.net/gitroot/timebrowse/timebrowse

  It works fine, but looks git tag is missing.  It's helpful to mark
  the commit on which you made a release.

  $ git tag -a v0.1

Cheers,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
