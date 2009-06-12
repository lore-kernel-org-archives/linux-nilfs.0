From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs2 with 2.6.30 kernel
Date: Fri, 12 Jun 2009 12:38:02 +0900 (JST)
Message-ID: <20090612.123802.78523749.ryusuke@osrg.net>
References: <4A311200.6020705@0bits.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A311200.6020705-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org

On Thu, 11 Jun 2009 18:17:36 +0400, Dave <dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Ryusuke
> 
> It seems git nilfs2-module doesn't compile any longet with 2.6.30. Is 
> the in-kernel code in 2.6.30 up to date ? Or can we get git updated for 
> 2.6.30 pls.

Yeah.  I would like to give priority to in-kernel code after this.
The in-kernel code in 2.6.30 is almost up to date.

At present, nilfs2-module 2.0.14 has a patch that is not included in
2.6.30.  But, it's exceptional.  I'm thinking that I first merge
updates to mainline and then backport them to the standalone package
for some time in the future.

I'll make an exception for bugfixes; they should be applied both tree
in parallel.

> Here's the compile failure:
> 
> home:~/nilfs2-module$ make
> make -C fs
> make[1]: Entering directory `/home/dave/nilfs2-module/fs'
> make -C /lib/modules/2.6.30/build SUBDIRS=/home/dave/nilfs2-module/fs 
> BUILD_DIR=/home/dave/nilfs2-module/fs modules
> make[2]: Entering directory `/usr/src/linux-2.6/linux-2.6.30'
>    CC [M]  /home/dave/nilfs2-module/fs/inode.o
> In file included from /home/dave/nilfs2-module/fs/inode.c:28:
> /home/dave/nilfs2-module/fs/nilfs.h: In function 'nilfs_init_acl':
> /home/dave/nilfs2-module/fs/nilfs.h:226: error: dereferencing pointer to 
> incomplete type
> make[3]: *** [/home/dave/nilfs2-module/fs/inode.o] Error 1
> make[2]: *** [_module_/home/dave/nilfs2-module/fs] Error 2
> make[2]: Leaving directory `/usr/src/linux-2.6/linux-2.6.30'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/dave/nilfs2-module/fs'
> make: *** [fs] Error 2
> 
> Thanks
> D

Yes, 2.6.30 includes some infuential changes as per usual.  I tried to
follow the changes, but soon gave up due to the change around mmap vfs
interface. (sigh)

Thanks,
Ryusuke Konishi
