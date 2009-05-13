From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Kernel patch
Date: Wed, 13 May 2009 16:34:04 +0900 (JST)
Message-ID: <20090513.163404.42111537.ryusuke@osrg.net>
References: <1241693160.5315.20.camel@flot-flash>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1241693160.5315.20.camel@flot-flash>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, volkov-6IceoeoMUCicTuHFI/JV5w@public.gmane.org

Hi Volkov,
On Thu, 07 May 2009 14:46:00 +0400, "volkov-6IceoeoMUCicTuHFI/JV5w@public.gmane.org" wrote:
> New patch is attached
> (for 2.6.28 linux kernel)
> 
> 
> INSTALL:
> ========================================================
> # cd /usr/src/
> 
> save patch_nilfs
> 
> # wget 
> https://www.nilfs.org/download/nilfs-2.0.12.tar.bz2
> # tar -jxf nilfs-2.0.12.tar.bz2
> # mv nilfs-2.0.12/fs linux/fs/nilfs
> # rm -rf milfs-2.0.12
> # cd linux
> # patch -p 1 <../patch_nilfs
> # make menuconfig
> 
> File systems  --->           
>  <*> NILFS 
> 
> # make
> # make install
> ========================================================
> 
> 
> Oleg Volkov

I put the patch in the nilfs web site and inserted this instruction to
the faq page:

 http://www.nilfs.org/en/faq.html

Thanks for your offer.

Ryusuke Konishi
