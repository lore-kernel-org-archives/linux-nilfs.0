From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: silent random symbolic link corruption
Date: Sun, 08 Mar 2009 22:07:20 +0900 (JST)
Message-ID: <20090308.220720.76959423.ryusuke@osrg.net>
References: <49872E1E.4090209@prnet.org> <49875F16.7060107@prnet.org>
	<20090308.153730.64866441.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090308.153730.64866441.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org

On Sun, 08 Mar 2009 15:37:30 +0900 (JST), Ryusuke Konishi wrote:
> Maybe nilfs should support nano second timestamps, but the inode of
> nilfs is unfortunately short 32-bits for this. :(
> 
> If I can allot one 64-bit field of the btree root array, this can be
> possible. But it breaks the compatibility.  Another candidate is an
> unused 64-bit field reserved for extended attribute. But I'd like to
> reserve it as is because it is enough important. So it's thorny.

I just noticed another possibility. The current nilfs inodes have
64-bit dtime field, which stores their deletion time and is not used
during inode is alive.  We may apply this for the nano-second time
stamps without breaking compatibility. I'll think for a second.

Cheers,
Ryusuke
