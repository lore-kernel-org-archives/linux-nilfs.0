From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: NILFS2 future
Date: Sun, 03 Aug 2008 01:52:11 +0900 (JST)
Message-ID: <20080803.015211.101568403.ryusuke@osrg.net>
References: <20080802110525.GA12210@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080802110525.GA12210-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org

Hi!

On Sat, 2 Aug 2008 13:05:25 +0200, Reinoud Zandijk wrote:
> Dear folks,
> 
> i've now come so far as that i can dump and read the root directory of a 
> nilfs2 filesystem. One thing i am wondering of though is the file format 
> stability? Are there changes on hand

NILFS 2.0.0 and the later 2.0.x are the versions to fix bugs or improve
perfomance problems due to immature implementation.
So, I'd like to avoid any changes that impact either backward or forward
compatibility in this series.

However, NILFS2 has many TODOs that may impact on that, such as atime
support, acl/xattr support, redundant super block support, B-tree based
directory implementation, and so forth.
New user requirement, or discussions and development in the kernel community
may also lead to big changes.

For changes like the atime support, NILFS2 can keep the compatibility
because adding metadata files (which are used for checkpoint management or
Disk Address Translation) to NILFS2 is possible. The acl/xattr support might
be possible by using similar scheme.
(Those enhanced version of NILFS2 should be released, I think, with version
 like 2.1.y, 2.2.y ...)

In general, the filesystem that doesn't have compatibility should be
regarded as different filesystem, especially for commonly used
filesystems or those adopted in the mainline kernel.
In this standpoint, big changes should be dealt with in NILFS3, but
we could think more flexibly because NILFS is not yet so popular ;-)
nor merged in the mainline.

> and if so how does the linux nilfs2 implementation deal with it?
> Is the kernel code automatically converting 
> the discs on write? or is there a transformation program to be provided? 
> 
> With regards,
> Reinoud

Hmm.., we don't have not yet so convenient solution, but the
cleaner daemon may help in the future;  it could serve on-line
disk format conversion with cooperation of the nilfs2 kernel code.
Anyone interested in that?

At present, we have to carefully implement new features on a case-by-case
basis not to lose compatibility.

Cheers,
Ryusuke
