From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: nilfs_cpfile_delete_checkpoints: cannot delete
 block
Date: Tue, 05 May 2009 18:51:55 +0200
Message-ID: <4A006EAB.6000206@prnet.org>
References: <D6LvKjCkn1gF.D60GTY3Z@mail.prnet.org>
	<20090506.004648.105122016.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090506.004648.105122016.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

I have applied your patch now. Also the garbage collector didn't crash 
until now. I have chosen to not reformat for further testing as there 
are only temporary files on this partition where loosing them would not 
be a big problem.

Bye,
David Arendt

Ryusuke Konishi wrote:
> Hi!
> On Tue,  5 May 2009 17:26:48 +0200, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
>   
>> Thank you.
>> I will try this patch in a few hours.  If I see it correctly the
>> patch will prevent this error in future and will not correct the
>> current error, so I suppose that after applying the patch I will
>> need to reformat the volume.
>>     
>
> I expect the patch will even fix the current error on the next GC, but
> you had better reformat the volume for safety.
>
> Ryusuke Konishi
>   
