From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: How does NILFS2 handle directory management
Date: Fri, 25 Sep 2009 14:21:09 +0200
Message-ID: <20090925122109.GD6624@aardappel.13thmonkey.org>
References: <20090910192619.GA1263@heethoofdje.13thmonkey.org>
	<20090911.102118.69189169.ryusuke@osrg.net>
	<20090911052213.GA24899@aardappel.13thmonkey.org>
	<20090911.154452.43227079.ryusuke@osrg.net>
	<20090914102731.GA154@aardappel.13thmonkey.org>
	<87hbusbud6.wl%jir@sekiba.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87hbusbud6.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi folks,

On Thu, Sep 24, 2009 at 05:49:09PM +0900, Jiro SEKIBA wrote:
> Reinoud Zandijk wrote:
> > > I think it should be considered along with ext3 approach.
> > 
> > What is is the ext3 approach? What is different compared to ext2? And is it
> > really such a big improvement? Will it complicate directory reading/writing
> > more?
> 
> ext3 approach is a hashed index for file names, stored on disk.
> So it always costs constant time to lookup the block filename stored.

So its basicly the same aproach as mine only with the disadvantage that the
hash is stored on-disc and hacked into the directory entries. That explains
the deletion penelty to be paid since the has to be updated. One could cheat
by not updating the hash on disc on deletion since its result will backfire on
lookup but thats silly.

Hmm...  with these things in mind, i'd still opt for the application of my
hash scheme in NiLFS2. It does have the penalty that the directory has to be
sequentially read once but no further penalties and no disc layout change.
Note that it *only* needs the directory contents to be read, the inodes don't
have to be visited/created and is thus a cheap alternative.

The only time it will be slower than ext3 is when you randomly delete files
from large directories visiting each directory once... an event thats not
remotely realistic.

Looking into the papers you sent me, they refer to my scheme as a `cached
index' if i read it correctly. The disadvantages they bring forward are not
that realistic in common use. Especially not if you keep the cache entries
small like the 24/28 bytes it takes for mine and if it also keeps track of the
free entries.

Thoughts?

With regards,
Reinoud Zandijk
