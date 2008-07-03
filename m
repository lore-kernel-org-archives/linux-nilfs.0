From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: NILFS specs
Date: Fri, 04 Jul 2008 01:38:26 +0900 (JST)
Message-ID: <20080704.013826.27467526.ryusuke@osrg.net>
References: <20080703114428.GA22708@aardappel.13thmonkey.org>
	<200807031514.21594.elentirmo.gilgalad@gmail.com>
	<20080703151041.GA24860@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080703151041.GA24860-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hello,

On Thu, 3 Jul 2008 17:10:41 +0200, Reinoud Zandijk wrote:
> Dear Gergely,
> 
> On Thu, Jul 03, 2008 at 03:14:16PM +0200, Gergely G?bor wrote:
> > On Thursday 03 July 2008 13:44:28 Reinoud Zandijk wrote:
> > > as a NetBSD developer i recently stumbled on NilFS and wondered where i
> > > could find the specs of the disc format to better understand the disc
> > > format. Is there a specification document around? Or should i look into the
> > > sources for it?
> >
> > Are you planning to port nifs2 to NetBSD? That would be great news!

and sounds tough. :-)

> Well that depends! :) depends on how much info i can get on the FS since 
> i'll have to rewrite most of it for various reasons :-/ I am currently 
> battling UDF still and its far from finished but i'd like to dig into nilfs 
> since i like its ideas.
>
> It'd be a shame if i have to develop my own version of nilfs and make them 
> incompatible :-(

Sorry for inconvenience.
I recognize it's one of what needs to be dissolved, and one of my colleagues
is working on writing the paper of NILFS2, but still not lead to publish it.

Though the documents of NILFS version 1 are available from
http://www.nilfs.org/en/links.html, the disk format was fairly changed
on version 2.  Especially the disk address translation file (DAT), which
was introduced in NILFS2 to implement garbage collection, made significant
difference among these two versions.

If you get tired of waiting, I recommend you to see ``nilfs_fs.h'' because
every definition around on-disk information is gathered in this header.

Best regards,
Ryusuke Konishi
