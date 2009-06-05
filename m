From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: power-fail tolerance
Date: Sat, 06 Jun 2009 04:30:56 +0900 (JST)
Message-ID: <20090606.043056.20506700.ryusuke@osrg.net>
References: <06B938618F632944B195981226FE50C0555290@exch10.ad.agi>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <06B938618F632944B195981226FE50C0555290-A6j10XXko5fUls26g4wG3Q@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, PSpiller-6frRqA8p9hS1Z/+hSey0Gg@public.gmane.org

Hi,
On Wed, 3 Jun 2009 08:58:14 -0700, "Spiller, Patrick" wrote:
> What is the current power-fail tolerance of the system?
> 
> In other words, are current versions of NILFS suited to sudden
> power-fails in a 100% guarenteed recoverable state?
>
> If not 100%, then what is the chance of a sudden power-fail
> resulting in a recoverable state?

It depends on the hardware, sublayer driver, and disk-cache setting
that you are using.

For example, nilfs uses io-barrier carefully to ensure filesystem
reliability, but some devices ignore the barriers and such affairs are
spoiling filesystem layer effort.

Except the fact, nilfs is designed to be recoverable from unexpected
power failures like journaling filesystems.  In general, nilfs is well
suited for such recovery because nilfs never overwrites existing
blocks except superblocks and reclaimed blocks by GC.  Disk write of
nilfs is ensured to be atomic with CRC checksums, and the result of
incomplete write is ignored.

You will see a message "NILFS: recovery complete." on mount time after
you met an unclean shutdown.

To tell you the truth, we have a few mount failure problems reported
in this mainling list after unclean shutdown.

That's going on for the nilfs root filesystem built in pendrives.  I'm
investigating the problem cooperating with some here.
 
> Can the block size be reduced down to 128 bytes?

You mean 1028 bytes?
If I remember correctly, the minimum block size of linux filesystems
is 1028 bytes.  Nilfs is supporting block sizes smaller that 4KB.

Cheers,
Ryusuke Konishi
