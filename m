From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: lscp & friends: indicate filesystem by directory
Date: Tue, 08 Mar 2011 11:31:22 +0900 (JST)
Message-ID: <20110308.113122.255573221.ryusuke@osrg.net>
References: <201103071051.25290.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201103071051.25290.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 7 Mar 2011 10:51:25 +0100, dexen deVries wrote:
> Hi,
> 
> I've suspended issuing my current patches for lscp & friends till I implement 
> the functionality Ryusuke mentioned.
> 
> Please review the following sketch of algorithm for all interactive utils:
> 
> char *dev, *dir, *object;
> char canonical[PATH_MAX + 2];
> struct stat statbuffer;
> 
> dev = dir = object = NULL;
> 
> if (optind < argc)
>                 object = argv[optind++];
> 
> if (object) {
> 	stat(object, &statbuffer);
> 	if (S_ISDIR(statbuffer))
> 		dir = myrealpath(object, canonical, sizeof(canonical));
> 	else
> 		dev = myrealpath(object, canonical, sizeof(canonical));
> }
> else
> 	dir = getwd(canonical);
> 
> /* a new function; traverses directory hierarchy up till it reaches nilfs 
> mountpoint */
> if (dir)
> 	dir = up_to_nilfs_mountpoint(dir);  
> 
> nilfs_open(dev, dir, ...);
 
Roughly seems OK to me.  (error handling is required at least for the
stat syscall, you know)
 
> The main difference to the current version is:
> if no object is explicitly indicated on the command line, the tool uses 
> current working directory. Thus by default it'd operate on the filesystem 
> holding the current working directory -- rather than the first NILFS2 in 
> /proc/mounts as it does currently.

Yeah, I think this is a nice idea.

If the current working directory is outside nilfs, it should work same
as before.  But this seems to be naturally achieved by the successive
up_to_nilfs_mountpoint() call if it returns NULL for out-of-nilfs
directories.  Looks well conceived.

> To indicate which filesystem is to be used, I'd like to print a header line 
> roughly like:
> # device: /dev/sdb3
>
> What's your opinion?

This may break compatibility of applications which parse lscp or lssu
output.  A separate device line seems a bad idea; it would change the
result for applications just doing a dummy read to skip the header.

I think users do not care about the device name for lscp or lssu
unless they actually want to check it.  So, making it an option (and
turning it off by default) would be better.

Also, looks like the device line does not have to be commented out ;)


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
